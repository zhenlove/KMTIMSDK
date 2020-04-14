//
//  PatientInfoCell.swift
//  KMTIMSDK
//
//  Created by Ed on 2020/4/8.
//

import UIKit
import TXIMSDK_TUIKit_iOS
import SnapKit

@objc(PatientInfoCell)
open class PatientInfoCell: TUIMessageCell {

    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc public lazy var iconImage = {
        return UIImageView(image: UIImage.km_image("icon_messagePatient"))
    }()

    @objc public lazy var patientTitle = { () -> UILabel in
        let lab = UILabel()
        lab.textColor = UIColor.hex(0x999999)
        lab.font = UIFont.systemFont(ofSize: 13)
        lab.text = "就诊人信息"
        return lab
    }()
    
    @objc public lazy var patientInfo = { () -> UILabel in
        let lab = UILabel()
        lab.textColor = UIColor.hex(0x333333)
        lab.font = UIFont.systemFont(ofSize: 15)
        return lab
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        container.addSubview(self.iconImage)
        container.addSubview(self.patientTitle)
        container.addSubview(self.patientInfo)
        
        container.backgroundColor = UIColor.white
        container.layer.masksToBounds = true
        container.layer.borderColor = UIColor.lightGray.cgColor
        container.layer.borderWidth = 1
        container.layer.cornerRadius = 5
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func fill(with data: TCommonCellData!) {
        super.fill(with: data)
        if let cellData = data as? PatientInfoCellData {
            patientInfo.text = cellData.memberName + "/" + cellData.age + "岁" + "/" + cellData.gender
        }
    }
    public override func layoutSubviews() {
        super.layoutSubviews()

        iconImage.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.size.equalTo(CGSize(width: 43, height: 43))
        }
        patientTitle.snp.makeConstraints { (make) in
            make.top.equalTo(iconImage.snp.top)
            make.left.equalTo(iconImage.snp.right).offset(10)
        }
        patientInfo.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconImage.snp.bottom)
            make.left.equalTo(iconImage.snp.right).offset(10)
        }
        
    }

}
