//
//  PrescribeCellData.swift
//  KMTIMSDK
//
//  Created by Ed on 2020/4/8.
//

import UIKit
import TXIMSDK_TUIKit_iOS
@objc(PrescribeCellData)
open class PrescribeCellData: TUIMessageCellData {
    
    @objc public var recipeImgUrl:String?
    @objc public var OPDRegisterID:String?
    
    public override func contentSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width/4, height: UIScreen.main.bounds.size.height/4)
    }
}
