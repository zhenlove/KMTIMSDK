//
//  KMOperateView.swift
//  KMAgoraRtc
//
//  Created by Ed on 2018/9/27.
//  Copyright © 2018 Ed. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class KMButton: UIButton {
    enum KMButtonImageStyle {
        case Left
        case Right
        case Top
        case Bottom
    }
    var space : CGFloat = 0
    var padding : CGFloat = 0
    var imageStyle : KMButtonImageStyle = .Left
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let labelWidth:CGFloat = titleLabel?.frame.size.width ?? 0.0
        let labelHeight:CGFloat = titleLabel?.frame.size.height ?? 0.0
        let image:UIImage = imageView?.image ?? UIImage.init()
        
        switch imageStyle {
        case .Left:
            let imageHeight = frame.size.height - 2 * space
            let edgeSpace = (frame.size.width - imageHeight - labelWidth - padding)/2
            self.imageEdgeInsets = UIEdgeInsets.init(top: space, left: edgeSpace, bottom: space, right: edgeSpace + labelWidth + padding)
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -image.size.width + imageHeight + padding, bottom: 0, right: 0)
            
        case .Right:
            let imageHeight = frame.size.height - 2 * space
            let edgeSpace = (frame.size.width - imageHeight - labelWidth - padding)/2
            self.imageEdgeInsets = UIEdgeInsets.init(top: space, left: edgeSpace + labelWidth + padding, bottom: space, right: edgeSpace)
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -image.size.width - padding - imageHeight, bottom: 0, right: 0)

        case .Top:
            var imageHeight = frame.size.height - (2 * space) - labelHeight - padding;
            if (imageHeight > image.size.height) {
                imageHeight = image.size.height
            }

            self.imageEdgeInsets = UIEdgeInsets.init(top: space,
                                                     left: (frame.size.width - imageHeight) / 2,
                                                     bottom: space + labelHeight + padding,
                                                     right: (frame.size.width - imageHeight) / 2)
            self.titleEdgeInsets = UIEdgeInsets.init(top: space + imageHeight + padding, left: -image.size.width, bottom: space, right: 0)
            
            
        case .Bottom:
            var imageHeight = frame.size.height - (2 * space) - labelHeight - padding;
            if (imageHeight > image.size.height) {
                imageHeight = image.size.height
            }
            self.imageEdgeInsets = UIEdgeInsets.init(top: space + labelHeight + padding, left: (frame.size.width - imageHeight) / 2, bottom: space, right: (frame.size.width - imageHeight) / 2)
            self.titleEdgeInsets = UIEdgeInsets.init(top: space, left: -image.size.width, bottom: padding + imageHeight + space, right: 0)
            
        }
    }
}

protocol KMMediaOperationDelegate :class {
    func clickeMicroButton(_ sender: UIButton)
    func clickedCameraButton(_ sender: UIButton)
    func clickedLoudspeakerButton(_ sender: UIButton)
    func clickedZoomOutButton(_ sender: UIButton)
    func clickedHangupButton(_ sender: UIButton)
    func clickedSwithCameraButton(_ sender: UIButton)
}

extension KMMediaOperationDelegate {
    func clickeMicroButton(_ sender: UIButton) {
        
    }
    func clickedCameraButton(_ sender: UIButton) {
        
    }
    func clickedLoudspeakerButton(_ sender: UIButton) {
        
    }
    func clickedZoomOutButton(_ sender: UIButton) {
        
    }
    func clickedHangupButton(_ sender: UIButton) {
        
    }
    func clickedSwithCameraButton(_ sender: UIButton) {
        
    }
}

class KMAgoraRTCTools: NSObject {
    static func getcurrentBundle() -> Bundle? {
        let bundel = Bundle.init(for: KMAgoraRTCTools.self)
        if let url = bundel.url(forResource: "AgoraRtc", withExtension: "bundle") {
            return Bundle.init(url: url)
        }
        return nil
    }
    static func getImage(named:String) -> UIImage? {
        return UIImage.init(named: named, in: getcurrentBundle(), compatibleWith: nil)
    }

}

class KMOperateView: UIView {
    
    var microphoneBtn: UIButton!//麦克风
    var cameraBtn: UIButton!//摄像头
    var speakerBtn: UIButton!//扬声器
    var switchBtn: UIButton!//切换前后摄像头
    var signalBtn: UIButton!//网络信号
    var hangUpBtn: UIButton!//挂断
    var collapseBtn: UIButton!//收起
    var stackView1: UIStackView!
    var stackView2: UIStackView!
    
    weak var delegate: KMMediaOperationDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        microphoneBtn = creatButtonImage(title: "麦克风",
                                         image: KMAgoraRTCTools.getImage(named: "icon_micro"),
                                         selectImage: KMAgoraRTCTools.getImage(named: "icon_micro_close"),
                                         disabledImage: KMAgoraRTCTools.getImage(named: "icon_micro_enable"),
                                         action: #selector(clickeMicrophoneBtn(_:)))
        
        cameraBtn = creatButtonImage(title: "摄像头",
                                     image: KMAgoraRTCTools.getImage(named: "icon_camera"),
                                     selectImage: KMAgoraRTCTools.getImage(named: "icon_camera_close"),
                                     disabledImage: KMAgoraRTCTools.getImage(named: "icon_camera_enable"),
                                     action: #selector(clickeCameraBtn(_:)))
        
        speakerBtn = creatButtonImage(title: "扬声器",
                                      image: KMAgoraRTCTools.getImage(named: "icon_loudspeaker"),
                                      selectImage: KMAgoraRTCTools.getImage(named: "icon_loudspeaker_close"),
                                      disabledImage: KMAgoraRTCTools.getImage(named: "icon_loudspeaker_enable"),
                                      action: #selector(clickeSpeakerBtn(_:)))
        
        switchBtn = creatButton(title: "切换",
                                image: KMAgoraRTCTools.getImage(named: "icon_camera_switch"),
                                action: #selector(clickeSwitchBtn(_:)))
        
        signalBtn = creatButton(title: "网络",
                                image: KMAgoraRTCTools.getImage(named: "icon_network-1"),
                                action: #selector(clickeSignalBtn(_:)))
        
        hangUpBtn = creatButton(title: "",
                                image: KMAgoraRTCTools.getImage(named: "icon_hangup"),
                                action: #selector(clickeHangUpBtn(_:)))
        
        collapseBtn = creatButton(title: "收起",
                                  image: KMAgoraRTCTools.getImage(named: "icon_zoomout"),
                                  action: #selector(clickeCollapseBtn(_:)))
        
        stackView1 = UIStackView.init()
        stackView1.axis = .horizontal
        stackView1.distribution = .equalSpacing
//        stackView1.alignment = .center
//        stackView1.isLayoutMarginsRelativeArrangement = true
        
        
        stackView2 = UIStackView.init()
        stackView2.axis = .horizontal
        stackView2.distribution = .equalSpacing
        
        
        addSubview(stackView1)
        addSubview(stackView2)
        
        stackView1.addArrangedSubview(microphoneBtn)
        stackView1.addArrangedSubview(cameraBtn)
        stackView1.addArrangedSubview(speakerBtn)
        stackView1.addArrangedSubview(switchBtn)
        
        stackView2.addArrangedSubview(signalBtn)
        stackView2.addArrangedSubview(hangUpBtn)
        stackView2.addArrangedSubview(collapseBtn)
        
        stackView1.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        
        stackView2.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(stackView1.snp_bottomMargin).offset(20)
            make.bottom.equalTo(self.snp_bottomMargin)
        }
        
    }
    
    @objc func clickeMicrophoneBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.clickeMicroButton(sender)
    }
    
    @objc func clickeCameraBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.clickedCameraButton(sender)
    }
    
    @objc func clickeSpeakerBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.clickedLoudspeakerButton(sender)
    }
    
    @objc func clickeSwitchBtn(_ sender: UIButton) {
        delegate?.clickedSwithCameraButton(sender)
    }
    
    @objc func clickeSignalBtn(_ sender: UIButton) {

    }
    
    @objc func clickeHangUpBtn(_ sender: UIButton) {
        delegate?.clickedHangupButton(sender)
    }
    
    @objc func clickeCollapseBtn(_ sender: UIButton) {
        delegate?.clickedZoomOutButton(sender)
    }
    
    func creatButton(title: String?,image: UIImage?,action: Selector?) -> UIButton {
        let button = KMButton.init(type: .custom)
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.imageStyle = .Top
        button.padding = 5
        if let newAction = action {
            button.addTarget(self, action: newAction, for: .touchUpInside)
        }
        return button
    }
    
    func creatButtonImage(title: String?,image: UIImage?,selectImage:UIImage?,disabledImage:UIImage?,action: Selector?) -> UIButton {
        let button = creatButton(title: title, image: image, action: action)
        button.setImage(selectImage, for: .selected)
        button.setImage(disabledImage, for: .disabled)
        return button
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
