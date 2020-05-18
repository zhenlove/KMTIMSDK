//
//  KMIMManager.swift
//  KMTIMSDK
//
//  Created by Ed on 2020/4/9.
//

import UIKit
import TXIMSDK_TUIKit_iOS

@objcMembers public class RoomStateChanged :NSObject, Codable {

    public var ChannelID : Int?
    public var ChargingState : Int?
    public var DisableWebSdkInteroperability : Bool?
    public var Duration : Int?
    public var ServiceID : String?
    public var ServiceType : Int?
    public var State : Int?
    public var TotalTime : Int?
    public var WebSdkType : Int?


}


public protocol RoomStateListenerDelegate :NSObject{
    func listener(channelID:Int?,customElem:RoomStateChanged)
}

public typealias Succ = ()->Void
public typealias Fail = (_ code:Int32,_ msg:String?)->Void

protocol BackHandler:NSObject {
    func navigationShouldPopOnBack() -> Bool
}

@objc
public class KMIMManager: NSObject {
    public weak var delegate:RoomStateListenerDelegate?
    @objc public static let sharedInstance = KMIMManager()
    lazy var loginParam = { TIMLoginParam() }()
    override init() {
        super.init()
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(onNewMessage),name: NSNotification.Name(rawValue: "TUIKitNotification_TIMMessageListener"), object: nil)
    }
    
    @objc func onNewMessage(notification:Notification){
            if let msgArr = notification.object as? [TIMMessage] {
                for msg in msgArr {
                    for i in 0..<msg.elemCount() {
                        if let elem = msg.getElem(i) {
                            if elem.isKind(of: TIMCustomElem.self) {
                                if let customElem = elem as? TIMCustomElem {
                                    if customElem.ext == "Room.StateChanged" {
                                        if let model = try? JSONDecoder().decode(RoomStateChanged.self, from: customElem.data){
                                            delegate?.listener(channelID: model.ChannelID, customElem: model)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    
    func setup(_ appid:Int) {
        TUIKit.sharedInstance()?.setup(withAppId: appid, logLevel: .LOG_NONE)
        let config = TUIKitConfig.default()
        config?.avatarType = .TAvatarTypeRadiusCorner;
        if let objc = config?.faceGroups.first {
            config?.faceGroups = [objc]
        }
        /// 医生默认头像
        config?.defaultAvatarImage = UIImage.km_image("icon_Default_Head")
        config?.defaultGroupAvatarImage = UIImage.km_image("icon_Default_Head")
        /// 患者默认头像
//        config?.defaultAvatarImage = UIImage.km_image("defualt_head")
//        config?.defaultGroupAvatarImage = UIImage.km_image("defualt_head")
    }
    
    @objc public func setupSig(appid:Int,userSig:String,identifier:String) {
        if let manager = TIMManager.sharedInstance() {
            if manager.getLoginStatus() != .STATUS_LOGINED {
                setup(appid)
            }
            loginParam.userSig = userSig
            loginParam.identifier = identifier
        }
    }
    
    @objc public func login(succ:@escaping Succ,fail:@escaping Fail) {
        if let manager = TIMManager.sharedInstance() {
            if manager.getLoginStatus() == .STATUS_LOGOUT {
                manager.login(loginParam, succ: {
                    succ()
                }, fail:{ (code, msg) in
                    fail(code,msg)
                })
            }
        }
    }
    @objc public func logout(succ:@escaping Succ,fail:@escaping Fail) {
        if let manager = TIMManager.sharedInstance() {
            if manager.getLoginStatus() == .STATUS_LOGINED {
                manager.logout({
                    succ()
                }) { (code, msg) in
                    fail(code,msg)
                }
            }
        }
    }
    
}

extension UIColor {
    static func hex(_ rgbValue:Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
}

extension Bundle {
    
    static func currentBundle() -> Bundle? {
        
        if let path = Bundle(for: KMIMManager.self).path(forResource: "KMTIMSDK", ofType: "bundle"){
            return Bundle(path: path)
        }
        return nil
    }
    
    
}


extension UIImage {
   @objc static func km_image(_ name:String) -> UIImage? {
        return UIImage(named: name, in: Bundle.currentBundle(), compatibleWith: nil)
    }
}

extension UINavigationController:UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if let items = navigationBar.items {
            if self.viewControllers.count < items.count {
                return true
            }
        }
        
        var shouldPod = true
        if let vc = self.topViewController as? BackHandler {
            vc.navigationShouldPopOnBack()
        }
        
        if shouldPod {
            DispatchQueue.main.async { [weak self] in
                self?.popViewController(animated: true)
            }
        }else{
            for view in navigationBar.subviews {
                if view.alpha > 0 && view.alpha < 1 {
                    UIView.animate(withDuration: 0.25) {
                        view.alpha = 1
                    }
                }
            }
        }
        return false
    }
}
