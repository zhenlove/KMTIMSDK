//
//  KMBaseModel.swift
//  KMTIMSDK_Example
//
//  Created by Ed on 2020/3/3.
//  Copyright © 2020 zhenlove. All rights reserved.
//

import Foundation

struct KMBaseModel : Codable {
    static func JSONModel<T>(_ type: T.Type, withKeyValues data:[String:Any]) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        let model = try JSONDecoder().decode(type, from: jsonData)
        return model
    }
}


struct KMRootClass<T:Codable> :Codable{
    let Data : T?
    let Msg : String?
    let Status : Int?
}

struct KMTokenModel:Codable {
    let Token:String?
}

