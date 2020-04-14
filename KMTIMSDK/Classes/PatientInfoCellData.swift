//
//  PatientInfoCellData.swift
//  KMTIMSDK
//
//  Created by Ed on 2020/4/8.
//

import UIKit
import TXIMSDK_TUIKit_iOS
@objc(PatientInfoCellData)
open class PatientInfoCellData: TUIMessageCellData {
    private var _dic:[String:Any]!
    @objc public var memberName:String! = ""
    @objc public var age:String! = "0"
    @objc public var gender:String! = "未知"
    @objc public var consultContent:String!
    @objc public var userFile:[String]?
    @objc public var userInfoDic:[String:Any]! {
        get{
            return _dic
        }
        set {
            _dic = newValue
            let genderArr = ["男","女","未知"]
            
            if let name = newValue?["MemberName"] as? String {
                memberName = name
            }

            if let ages = newValue?["Age"] as? Int {
                age = "\(ages)"
            }
            
            if let gen = newValue?["Gender"] as? Int {
                gender = genderArr[gen]
            }
            consultContent = newValue?["ConsultContent"] as? String
            userFile = newValue?["UserFiles"] as? [String]
        }
    }
    
    public override func contentSize() -> CGSize {

        guard let str = memberName + "/" + age + "岁" + "/" + gender  as? NSString else {
            return CGSize.zero
        }
        let size1  = str.boundingRect(with: CGSize(width: 300, height: Int.max), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15)], context: nil)
        let str1:NSString = "就诊人信息"
        let size2 = str1.boundingRect(with: CGSize(width: 300, height: Int.max), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15)], context: nil)
        
        guard let width = [size1.width,size2.width].max() else {
            return CGSize.zero
        }
        var size = CGSize(width:width + 43 + 20 + 10, height:20+43)
        return size
    }
}
