//
//  KMAgoraRtcView.swift
//  KMAgoraRtc
//
//  Created by Ed on 2018/9/27.
//  Copyright © 2018 Ed. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class KMAgoraRtcView: KMFloatView {
    
    lazy var localVideo = UIView()
    lazy var remoteVideo = UIView()
    lazy var localVideoView = UIView()
    lazy var remoteVideoView = UIView()
    lazy var operateView = KMOperateView()

    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let stateHeight = UIApplication.shared.statusBarFrame.size.height
    var isExchange = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black
        
        addSubview(localVideo)
        addSubview(remoteVideo)
        addSubview(operateView)
        remoteVideo.addSubview(remoteVideoView)
        localVideo.addSubview(localVideoView)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewTapped))
        remoteVideo.addGestureRecognizer(tapGestureRecognizer)
        remoteVideo.isUserInteractionEnabled = true
        
        
        
        localVideo.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        remoteVideo.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(margin)
            make.top.equalTo(self).offset(stateHeight)
            make.width.equalTo(screenWidth * 0.25)
            make.height.equalTo(screenHeight * 0.25)
        }
        
        localVideoView.snp.makeConstraints { (make) in
            make.edges.equalTo(localVideo)
        }
        remoteVideoView.snp.makeConstraints { (make) in
            make.edges.equalTo(remoteVideo)
        }
        
        operateView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self.snp_bottomMargin)
        }
        
        
    }
    
    deinit {
        print("我的视图释放了")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 交换两个视图大小及位置
    func exchange(firstView: UIView,secondView: UIView) {
        let firstSuperView = firstView.superview
        let secondSuperView = secondView.superview
        
        if firstSuperView?.isHidden ?? true || secondSuperView?.isHidden ?? true{
            return
        }

        firstView.removeFromSuperview()
        secondView.removeFromSuperview()
        
        firstSuperView?.addSubview(secondView)
        secondSuperView?.addSubview(firstView)
        
        secondView.snp.makeConstraints { (make) in
            make.edges.equalTo(firstSuperView!)
        }
        firstView.snp.makeConstraints { (make) in
            make.edges.equalTo(secondSuperView!)
        }
    }
    
    @objc func ViewTapped() {
        
        if isExchange {
            isExchange = false
            exchange(firstView: localVideoView, secondView: remoteVideoView)
        } else {
            isExchange = true
            exchange(firstView: remoteVideoView, secondView: localVideoView)
        }
    }
}
