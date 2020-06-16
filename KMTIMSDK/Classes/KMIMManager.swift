//
//  KMIMManager.swift
//  KMTIMSDK
//
//  Created by Ed on 2020/4/9.
//

import UIKit
import TXIMSDK_TUIKit_iOS
import KMTools

public typealias Succ = ()->Void
public typealias Fail = (_ code:Int32,_ msg:String?)->Void

/// 可以通过通知监听IM消息【TUIKitNotification_TIMMessageListener】
@objc(KMIMManager)
public class KMIMManager: NSObject {
    @objc public static let sharedInstance = KMIMManager()
    private lazy var loginParam = { TIMLoginParam() }()
    private override init() {
        super.init()
    }
    
    private func setup(_ appid:Int, _ userType:Int) {
        TUIKit.sharedInstance()?.setup(withAppId: appid, logLevel: .LOG_NONE)
        let config = TUIKitConfig.default()
        config?.avatarType = .TAvatarTypeRadiusCorner;
        if let objc = config?.faceGroups.first {
            config?.faceGroups = [objc]
        }
        if userType == 2 {
            /// 医生默认头像
            config?.defaultAvatarImage = UIImage.km_image("icon_Default_Head")
            config?.defaultGroupAvatarImage = UIImage.km_image("icon_Default_Head")
        }
        if userType == 1 {
            /// 患者默认头像
            config?.defaultAvatarImage = UIImage.km_image("defualt_head")
            config?.defaultGroupAvatarImage = UIImage.km_image("defualt_head")
        }
    }
    /// userType: userType: 0,系统用户；1,患者；2,医生；4,药店工作站用户
    @objc public func setupSig(appid:Int,userSig:String,identifier:String,userType:Int) {
        setup(appid,userType)
        loginParam.userSig = userSig
        loginParam.identifier = identifier
    }
    
    @objc public func login(succ:@escaping Succ,fail:@escaping Fail) {
        TIMManager.sharedInstance().login(loginParam, succ: {
            succ()
        }, fail:{ (code, msg) in
            fail(code,msg)
        })
    }
    @objc public func logout(succ:@escaping Succ,fail:@escaping Fail) {
        TIMManager.sharedInstance().logout({
            succ()
        }) { (code, msg) in
            fail(code,msg)
        }
    }
    
}

extension Bundle {
    static func currentBundle() -> Bundle? {
        return Bundle.bundle("KMTIMSDK")
    }
}


extension UIImage {
   @objc static func km_image(_ name:String) -> UIImage? {
        return UIImage(named: name, in: Bundle.currentBundle(), compatibleWith: nil)
    }
}
