//
//  PrescribeCell.swift
//  KMTIMSDK
//
//  Created by Ed on 2020/4/8.
//

import UIKit
import TXIMSDK_TUIKit_iOS
import SnapKit
import Kingfisher
@objc(PrescribeCell)
open class PrescribeCell: TUIMessageCell {
    
    
    @objc public lazy var prescribeImageView = { () -> UIImageView in
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
        container.addSubview(prescribeImageView)
        
        container.backgroundColor = UIColor.white
        container.layer.masksToBounds = true
        container.layer.borderColor = UIColor.lightGray.cgColor
        container.layer.borderWidth = 1
        container.layer.cornerRadius = 5
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public override func fill(with data: TCommonCellData!) {
        super.fill(with: data)
        if let cellData = data as? PrescribeCellData,
            let urlStr = cellData.recipeImgUrl {
            prescribeImageView.kf.setImage(with: URL(string: urlStr))
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        prescribeImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(container.snp.edges)
        }
    }

}
