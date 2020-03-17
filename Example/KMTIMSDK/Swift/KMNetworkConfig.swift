//
//  KMNetworkConfig.swift
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/3.
//  Copyright © 2020 zhenlove. All rights reserved.
//

import Foundation

@objc(Environment)
enum Environment : NSInteger{
    case Testing1 //测试环境
    case Testing2 //41测试环境
    case Testing3 //42测试环境
    case Release1 //预发布环境
    case Release2 //预发布环境2
    case Production //生产环境
}

protocol SetupEnvironment {
    @discardableResult
    static func setEnvironment(_ reason: Environment) -> String
}

class BaseUrl:SetupEnvironment {
   static func setEnvironment(_ reason: Environment) -> String {
        switch reason {
        case .Testing1:
            return "https://tapi.kmwlyy.com:8015/"
        case .Testing2:
            return "https://tapi1.kmwlyy.com:8015/"
        case .Testing3:
            return "https://tapi2.kmwlyy.com:8015/"
        case .Release1:
            return "https://prapi.kmwlyy.com/"
        case .Release2:
            return "https://prapi1.kmwlyy.com/"
        case .Production:
            return "https://api.kmwlyy.com/"
        }
    }
}

class DoctorBaseUrl:SetupEnvironment {
    static func setEnvironment(_ reason: Environment) -> String {
        switch reason {
        case .Testing1:
            return "https://tapi.kmwlyy.com:8015/"
        case .Testing2:
            return "https://tdoctorapi.kmwlyy.com:8015/"
        case .Testing3:
            return "https://tdoctorapi2.kmwlyy.com:8015/"
        case .Release1:
            return "https://prdoctorapi.kmwlyy.com/"
        case .Release2:
            return "https://prdoctorapi1.kmwlyy.com/"
        case .Production:
            return "https://doctorapi.kmwlyy.com/"
        }
    }
}

class CommonBaseUrl:SetupEnvironment {
    static func setEnvironment(_ reason: Environment) -> String {
        switch reason {
        case .Testing1:
            return "https://tcommonapi.kmwlyy.com:8015/"
        case .Testing2:
            return "https://tcommonapi1.kmwlyy.com:8015/"
        case .Testing3:
            return "https://tcommonapi2.kmwlyy.com:8015/"
        case .Release1:
            return "https://prcommonapi.kmwlyy.com/"
        case .Release2:
            return "https://prcommonapi1.kmwlyy.com/"
        case .Production:
            return "https://commonapi.kmwlyy.com/"
        }
    }
}

class UserBaseUrl:SetupEnvironment {
    static func setEnvironment(_ reason: Environment) -> String {
        switch reason {
        case .Testing1:
            return "https://tuserapi.kmwlyy.com:8015/"
        case .Testing2:
            return "https://tuserapi1.kmwlyy.com:8015/"
        case .Testing3:
            return "https://tuserapi2.kmwlyy.com:8015/"
        case .Release1:
            return "https://pruserapi.kmwlyy.com/"
        case .Release2:
            return "https://pruserapi1.kmwlyy.com/"
        case .Production:
            return "https://userapi.kmwlyy.com/"
        }
    }
}
class FileStoreUrl:SetupEnvironment {
    static func setEnvironment(_ reason: Environment) -> String {
        switch reason {
        case .Testing1:
            return "https://tstore.kmwlyy.com:8015/"
        case .Testing2:
            return "https://tstore1.kmwlyy.com:8015/"
        case .Testing3:
            return "https://tstore2.kmwlyy.com:8015/"
        case .Release1:
            return "https://prstore.kmwlyy.com/"
        case .Release2:
            return "https://prstore1.kmwlyy.com/"
        case .Production:
            return "https://store.kmwlyy.com/"
        }
    }
}
class DrugstoreBaseUrl:SetupEnvironment {
    static func setEnvironment(_ reason: Environment) -> String {
        switch reason {
        case .Testing1:
            return "https://tydapi.kmwlyy.com:8015/"
        case .Testing2:
            return "https://tydapi1.kmwlyy.com:8015/"
        case .Testing3:
            return "https://tydapi2.kmwlyy.com:8015/"
        case .Release1:
            return "https://prydapi.kmwlyy.com/"
        case .Release2:
            return "https://prydapi1.kmwlyy.com/"
        case .Production:
            return "https://ydapi.kmwlyy.com/"
        }
    }
}

class RemoteAuditUrl:SetupEnvironment {
    static func setEnvironment(_ reason: Environment) -> String {
        switch reason {
        case .Testing1:
            return "https://tysapi.kmwlyy.com:8015/"
        case .Testing2:
            return "https://tysapi1.kmwlyy.com:8015/"
        case .Testing3:
            return "https://tysapi2.kmwlyy.com:8015/"
        case .Release1:
            return "https://prysapi.kmwlyy.com/"
        case .Release2:
            return "https://prysapi2.kmwlyy.com/"
        case .Production:
            return "https://ysapi.kmwlyy.com/"
        }
    }
}





@objc(KMServiceModel)
@objcMembers open class KMServiceModel: NSObject {
    
     static var appId:String?
     static var appSecret:String?
     static var appKey:String?
     static var orgId:String?
     
     static var apptoken : String?
     static var usertoken: String?

     static var baseURL:String!
     static var doctorBaseUrl:String!
     static var commonBaseUrl:String!
     static var userBaseUrl:String!
     static var fileStoreUrl:String!
     static var drugstoreBaseUrl:String!
     static var remoteAuditUrl:String!
    
     @discardableResult
     static func setupParameter(appid:String, appsecret:String, appkey:String, orgid:String, environment:Environment)-> Bool {
        
        appId = appid
        appSecret = appsecret
        appKey = appkey
        orgId = orgid
        
        baseURL = BaseUrl.setEnvironment(environment)
        doctorBaseUrl = DoctorBaseUrl.setEnvironment(environment)
        commonBaseUrl = CommonBaseUrl.setEnvironment(environment)
        userBaseUrl = UserBaseUrl.setEnvironment(environment)
        fileStoreUrl = FileStoreUrl.setEnvironment(environment)
        drugstoreBaseUrl = DrugstoreBaseUrl.setEnvironment(environment)
        remoteAuditUrl = RemoteAuditUrl.setEnvironment(environment)
        
        return true
    }

}
