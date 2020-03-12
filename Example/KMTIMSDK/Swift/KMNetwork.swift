//
//  KMNetwork.swift
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/2.
//  Copyright © 2020 zhenlove. All rights reserved.
//

import Foundation
import Alamofire


@objc(KMHTTPMethod)
public enum KMHTTPMethod: NSInteger {
    case Options
    case Get
    case Head
    case Post
    case Put
    case Patch
    case Delete
    case Trace
    case Connect
}

func getHTTPMethod(method:KMHTTPMethod)-> HTTPMethod {
    switch method {
    case .Options:
        return .options
    case .Get:
        return .get
    case .Head:
        return .head
    case .Post:
        return .post
    case .Put:
        return .put
    case .Patch:
        return .patch
    case .Delete:
        return .delete
    case .Trace:
        return .trace
    case .Connect:
        return .connect
    }
}

typealias KMURLRquestSucess = (_ response:HTTPURLResponse? ,_ reuslt : Dictionary<String, Any>? )-> Void
typealias KMURLRquestFailure = (_ response:HTTPURLResponse? ,_ error:Error?)-> Void

@objc(KMNetwork)
class KMNetwork: NSObject {
     static var sessionManager: SessionManager = {
        let tSessionManager = SessionManager.default
        tSessionManager.adapter = KMAdapter()
        tSessionManager.retrier = KMRetrier()
        return tSessionManager
    }()
}

@objc
extension KMNetwork {

    static func request(url:String,
                        method:KMHTTPMethod,
                        parameters:[String: Any]?,
                        isHttpBody:Bool,
                        requestSucess sucess:@escaping KMURLRquestSucess,
                        requestFailure failure:@escaping KMURLRquestFailure) -> Void {
        KMNetwork
        .sessionManager
        .request(url, method: getHTTPMethod(method: method), parameters: parameters, encoding: isHttpBody ? URLEncoding.default :JSONEncoding.default)
        .validateDataStatus(statusCode: 5)
        .responseJSON { (dataResponse) in
                if dataResponse.result.isSuccess{
                    sucess(dataResponse.response,dataResponse.result.value as? Dictionary<String, Any>)
                }
                if dataResponse.result.isFailure{
                    failure(dataResponse.response,dataResponse.result.error)
                }
        }
    }
}

