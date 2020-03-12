//
//  KMRetrier.swift
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/3.
//  Copyright © 2020 zhenlove. All rights reserved.
//

import Foundation
import Alamofire
class KMRetrier: RequestRetrier {
    
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        lock.lock() ; defer { lock.unlock() }

        if let error = error as? AFError, error.responseCode == 5 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {

                refreshTokens(completion: { [weak self] (succeeded) in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                })
            }
        } else {
            completion(false, 0.0)
        }
    }

}

extension KMRetrier {
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping (_ succeeded: Bool) -> Void) {
        guard !isRefreshing else { return }

        isRefreshing = true

        guard let baseURL = KMServiceModel.baseURL else {
            print(" baseURL 不能为空")
            return
        }
        guard let appId = KMServiceModel.appId else {
            print("appId 不能为空 ")
            return
        }
        guard let appSecret = KMServiceModel.appSecret else {
            print("appSecret 不能为空")
            return
        }
        
        let serviceString = baseURL + "/Token/get"
        
        let paramsDict:Parameters = ["appId":appId,"appSecret":appSecret]
        
        Alamofire.request(serviceString, method: .get, parameters: paramsDict)
            .responseObject { [weak self] (dataResponse : DataResponse<KMRootClass<KMTokenModel>>) in
                
                guard let strongSelf = self else { return }
                
                dataResponse.result.ifSuccess {
                    if let data = dataResponse.result.value?.Data {
                        KMServiceModel.apptoken = data.Token;
                        completion(true)
                    }
                }
                completion(false)
                strongSelf.isRefreshing = false
        }
    }
}
