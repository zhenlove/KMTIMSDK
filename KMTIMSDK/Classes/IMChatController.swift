//
//  IMChatController.swift
//  KMTIMSDK
//
//  Created by Ed on 2020/4/9.
//

import UIKit
import ImSDK
import MobileCoreServices
import TXIMSDK_TUIKit_iOS
import SnapKit

//咨询状态(0-未筛选、1-未领取、2-已领取、3-未回复、4-已回复、5-已完成)
public enum ConsultatingState :Int {
    
    case _default = -1
    case _nfiltered = 0
    case _unclaimed = 1
    case _claimed = 2
    case _notReply = 3
    case _replied = 4
    case _finished = 5
}

extension UIDevice {
    static func getBottomSafeAreaHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
        } else {
            return 0.0
        }
    }
}


let IITextView_Height:CGFloat = 49.0
let IIBottom_SafeHeight:CGFloat = UIDevice.getBottomSafeAreaHeight()


public protocol IMChatControllerDelegate: NSObject {
    func clickePatientInfo(_ infoDic:[String:Any])
    func clickePrescribe(_ prescribeUrl:String?, _ opdRegisterID:String?)
    func clickeBackBtnController() -> Bool
}


public class IMChatController: UIViewController {

    public var state:ConsultatingState?
    public var convId:String!
    public weak var delegate:IMChatControllerDelegate?
    
    
    lazy var conversation = { TIMManager.sharedInstance()?.getConversation(.GROUP, receiver: self.convId) }()
    lazy var moreMenus = { [TUIInputMoreCellData.photo,TUIInputMoreCellData.picture] }()
    lazy var messageController = { () -> TUIMessageController in
        let vc = TUIMessageController()
        vc.delegate = self
        addChild(vc)
        if let con = self.conversation {
            vc.setConversation(con)
        }
        return vc
    }()
    lazy var inputController = { () -> TUIInputController in
        let vc = TUIInputController()
        vc.delegate = self
        vc.moreView.setData(self.moreMenus)
        addChild(vc)
        return vc
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(messageController.tableView)
        view.addSubview(inputController.view)
        
        messageController.tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(inputController.view.snp_top)
        }
        inputController.view.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(IITextView_Height + IIBottom_SafeHeight)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        if let draft = conversation?.getDraft() {
            for i in 0..<draft.elemCount() {
                if let elem = draft.getElem(i) {
                    if elem.isKind(of: TIMTextElem.self) {
                        if let textElem = elem as? TIMTextElem {
                            inputController.inputBar.inputTextView.text = textElem.text
                            conversation?.setDraft(nil)
                            break
                        }
                    }
                }
            }
        }
    }
    
    public override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            saveDraft()
        }
    }
    
    func saveDraft() {
        if let draft = inputController.inputBar.inputTextView.text as? NSString {
            let str = draft.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let msg = TIMMessageDraft()
            let text = TIMTextElem()
            text.text = str
            msg.add(text)
            conversation?.setDraft(msg)
        }else{
            conversation?.setDraft(nil)
        }
    }
    
    func sendMessage(_ message:TUIMessageCellData!) {
        messageController.sendMessage(message)
    }

}

extension UIViewController:UIGestureRecognizerDelegate {
    
    
    @_dynamicReplacement(for:viewDidAppear(_:))
    func swizzle_viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let vc = navigationController?.topViewController as? IMChatControllerDelegate{
            return vc.clickeBackBtnController()
        }
        if let vc = navigationController?.topViewController as? IMChatController {
            return vc.delegate?.clickeBackBtnController() ?? true
        }
        return true
    }
}


extension IMChatController:TMessageControllerDelegate {
    public func didTap(in controller: TUIMessageController!) {
        inputController.reset()
    }
    
    public func didHideMenu(in controller: TUIMessageController!) {
        inputController.inputBar.inputTextView.overrideNextResponder = nil
    }
    
    public func messageController(_ controller: TUIMessageController!, willShowMenuInCell view: UIView!) -> Bool {
        if inputController.inputBar.inputTextView.accessibilityElementIsFocused() {
            inputController.inputBar.inputTextView.overrideNextResponder = view
            return true
        }
        return false
    }
    
    public func messageController(_ controller: TUIMessageController!, onNewMessage data: TIMMessage!) -> TUIMessageCellData! {
        if let elem = data.getElem(0) {
            if elem.isKind(of: TIMCustomElem.self) {
                if let customElem = elem as? TIMCustomElem,
                    var dic = Dictionary<String, Any>.ToJson(customElem.data){
                    
                    if customElem.ext == "User.DiseaseDesc" {//病情描述
                        let cellData = PatientInfoCellData(direction: data.isSelf() ? .MsgDirectionOutgoing : .MsgDirectionIncoming)
                        dic["UserImage"] = TIMFriendshipManager.sharedInstance()?.queryUserProfile(data.sender())?.faceURL
                        cellData.userInfoDic = dic
                        if let urlStr = TIMFriendshipManager.sharedInstance()?.queryUserProfile(data.sender())?.faceURL,
                            let url =  URL(string:urlStr ){
                            cellData.avatarUrl = url
                        }
                        return cellData
                    }
                    if customElem.ext == "Room.DurationChanged" || customElem.ext == "Notice" {//房间持续时间变更
                        let cellData = TUISystemMessageCellData(direction: data.isSelf() ? .MsgDirectionOutgoing : .MsgDirectionIncoming)
                        cellData.content = customElem.desc
                        return cellData
                    }
                    if customElem.ext == "Room.StateChanged" {//房间状态
                        
                    }
                    if customElem.ext == "AIMed.Recommend" {//推荐
                        
                    }
                    if customElem.ext == "Diagnose.Summary.Submit" || customElem.ext == "Order.Buy.Recipe" {//购买处方
                        if let customArr = dic as? [[String:Any]] {
                            let cellData = PrescribeCellData(direction: data.isSelf() ? .MsgDirectionOutgoing : .MsgDirectionIncoming)
                            if let pecipeImgUrl = customArr[0]["RecipeImgUrl"] as? String {
                                cellData.recipeImgUrl = pecipeImgUrl
                            }
                            if let registerID = customArr[0]["OPDRegisterID"] as? String {
                                cellData.OPDRegisterID = registerID
                            }
                            return cellData
                        }
                    }
                    if customElem.ext == "Recipe.Preview" {//处方预览
                        
                    }
                    if customElem.ext == "User.TransferTreatmen" {//当前看诊医生已离线请稍候
                        
                    }
                    if customElem.ext == "Room.Hangup" {//挂断
                        
                    }
                }
            }
        }
        return nil
    }
    
    public func messageController(_ controller: TUIMessageController!, onShowMessageData data: TUIMessageCellData!) -> TUIMessageCell! {
        if data.isKind(of: PatientInfoCellData.self) {
            let cell = PatientInfoCell(style: .default, reuseIdentifier: "PatientInfoCell")
            cell.fill(with: data)
            return cell
        }
        if data.isKind(of: PrescribeCellData.self) {
            let cell = PrescribeCell(style: .default, reuseIdentifier: "PrescribeCell")
            cell.fill(with: data)
            return cell
        }
        return nil
    }
    
    public func messageController(_ controller: TUIMessageController!, onSelectMessageAvatar cell: TUIMessageCell!) {
        
    }
    
    public func messageController(_ controller: TUIMessageController!, onSelectMessageContent cell: TUIMessageCell!) {
        if cell.isKind(of: PatientInfoCell.self) {
            if let cellData = cell.messageData as? PatientInfoCellData {
                delegate?.clickePatientInfo(cellData.userInfoDic)
            }
            
        }
        if cell.isKind(of: PrescribeCell.self) {
            if let cellData = cell.messageData as? PrescribeCellData {
                delegate?.clickePrescribe(cellData.recipeImgUrl, cellData.OPDRegisterID)
            }
        }
    }
}
extension IMChatController:TInputControllerDelegate {
    
    public func inputController(_ inputController: TUIInputController!, didChangeHeight height: CGFloat) {
        UIView.animate(withDuration: 0.3,
                       delay: 0 ,
                       options: .curveEaseOut,
                       animations: { [weak self] in
            
                        inputController.view.snp.updateConstraints { (make) in
                            make.height.equalTo(height)
                        }
                        self?.messageController.scroll(toBottom: false)
                        self?.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    public func inputController(_ inputController: TUIInputController!, didSendMessage msg: TUIMessageCellData!) {
        messageController.sendMessage(msg)
    }
    
    public func inputController(_ inputController: TUIInputController!, didSelect cell: TUIInputMoreCell!) {
        if cell.data == TUIInputMoreCellData.photo {
            selectPhotoForSend()
        }
        if cell.data == TUIInputMoreCellData.picture {
            takePictureForSend()
        }
    }
    
    func selectPhotoForSend() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    func takePictureForSend() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
}

extension IMChatController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.delegate = nil
        picker.dismiss(animated: true) { [weak self] in
            
            if let mediaType = info[.mediaType] as? String,
                 let typeImage = kUTTypeImage as? String {
                    if mediaType == typeImage {
                        if var image = info[.originalImage] as? UIImage {
                            if image.imageOrientation != .up {
                                if let aspectRatio = [1920/image.size.width,1920/image.size.height].max() {
                                    let aspectWidth = image.size.width * aspectRatio
                                    let aspectHeight = image.size.height * aspectRatio
                                    
                                    UIGraphicsBeginImageContext(CGSize(width: aspectWidth, height: aspectHeight))
                                    image.draw(in: CGRect(x: 0, y: 0, width: aspectWidth, height: aspectHeight))
                                    if let img = UIGraphicsGetImageFromCurrentImageContext() {
                                        image = img
                                    }
                                    UIGraphicsEndImageContext()
                                }
                            }
                            let data = image.jpegData(compressionQuality: 0.75)
                            var path = NSHomeDirectory()
                            path.append("/Documents/com_tencent_imsdk_data/image/")
                            path.append(THelper.genImageName(nil))
                            FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
                            
                            let uiImage = TUIImageMessageCellData(direction: .MsgDirectionOutgoing)
                            uiImage.path = path
                            uiImage.length = data?.count as! Int
                            self?.sendMessage(uiImage)
                    }
                }
            }
        }
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension Dictionary {
    static func ToJson(_ data:Data) -> Self? {
        return try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<Key, Value>
    }
}


extension IMChatController:BackHandler {
    func navigationShouldPopOnBack() -> Bool {
        if let dele = delegate {
            return dele.clickeBackBtnController()
        }
        return true
    }
}
