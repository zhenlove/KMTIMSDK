//
//  CustomExtensioon.swift
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/3.
//  Copyright © 2020 zhenlove. All rights reserved.
//

import Foundation
import CommonCrypto
import Alamofire
extension String  {
    //md5加密字符串
    func MD5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return hash.uppercased
    }

    //获取随机字符串
    static func generateRandomString(_ length:Int) -> String {
        let kRandomAlphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = String.init(repeating: "", count: length)
        for _ in 0 ..< length {
            let serialNumber = arc4random_uniform(UInt32(kRandomAlphabet.count))
            let range = Range.init(NSRange.init(location:Int(serialNumber) , length: 1), in: kRandomAlphabet)
            randomString += String(kRandomAlphabet[range!])
        }
        return randomString
    }
    
    //获取签名
    static func sign(_ appToken:String?, _ userToken:String?, _ appKey:String?,_ random:String) -> String? {
        
        guard let appKey = appKey else {
            print("appKey  不能为空")
            return nil
        }
        var string = "apptoken=\(appToken ?? "")&noncestr=\(random)"
        if let userToken = userToken {
            string += "&usertoken=\(userToken)"
        }
        string += "&appkey=\(appKey)"

        return string.MD5()
    }
    
    public func jsonToDictionary() -> Dictionary<String, AnyObject>? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
}


extension Request {
    public static func serializeResponseObject<T:Codable>(
        encoding: String.Encoding?,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<T>
    {
        guard error == nil else { return .failure(error!) }
        //
        // if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success("") }
        //
        guard let validData = data else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
        }
        
        var convertedEncoding = encoding
        
        if let encodingName = response?.textEncodingName as CFString?, convertedEncoding == nil {
            convertedEncoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(
                CFStringConvertIANACharSetNameToEncoding(encodingName))
            )
        }
        
        let actualEncoding = convertedEncoding ?? .isoLatin1
        
        if let string = String(data: validData, encoding: actualEncoding) {
            let data = string.data(using: String.Encoding.utf8)
            if let decoded =  try? JSONDecoder().decode(T.self, from: data!){
                return .success(decoded)
            }else{
                return .failure(error!)
            }
        } else {
            return .failure(AFError.responseSerializationFailed(reason: .stringSerializationFailed(encoding: actualEncoding)))
        }
    }
}

 extension DataRequest {
    
    public static func objectResponseSerializer<T:Codable>(encoding: String.Encoding? = nil ) -> DataResponseSerializer<T> {
        return DataResponseSerializer<T> { _, response, data, error in
            return Request.serializeResponseObject(encoding: encoding, response: response, data: data, error: error)
        }
    }
    
    @discardableResult
    public func responseObject<T:Codable>(
        queue: DispatchQueue? = nil,
        encoding: String.Encoding? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self {
            return response(
                queue: queue,
                responseSerializer: DataRequest.objectResponseSerializer(encoding: encoding),
                completionHandler: completionHandler
            )
    }
    
    @discardableResult
    public func validateDataStatus(statusCode acceptableStatusCodes: Int) -> Self {
       
        
        return  validate {  request, response, data  in
            
            var dic:[String:AnyObject]?
            
            if let data = data {
                do {
                    dic =  try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
                } catch let error as NSError {
                    print(error)
                }
            }
            
            struct KMBaseClass: Codable{
                let Msg : String?
                let Status : Int?
            }
            
            if let dic = dic {
                let rootModel = try? KMBaseModel.JSONModel(KMBaseClass.self, withKeyValues: dic)
                if rootModel?.Status == acceptableStatusCodes {
                    return .failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: acceptableStatusCodes)))
                }
            }
            return .success
        }
    }
    
}
