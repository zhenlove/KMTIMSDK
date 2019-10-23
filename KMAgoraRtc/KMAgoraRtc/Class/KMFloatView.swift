//
//  KMFloatView.swift
//  KMAgoraRtc
//
//  Created by Ed on 2018/9/26.
//  Copyright © 2018 Ed. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    public class func isIphoneX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
}

let margin : CGFloat = 2

protocol KMFloatViewDelegate :class {
    func clickeTappedFloatView()
}

class KMFloatView: UIView {
    weak var delegate: KMFloatViewDelegate?
    var zoomOut :Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewTappedNew))
        self.addGestureRecognizer(tapGestureRecognizer)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if zoomOut {
            let touch = touches.first
            let currentPoint = touch?.location(in: UIApplication.shared.keyWindow)
            let previousPoint = touch?.previousLocation(in: UIApplication.shared.keyWindow)
            if let curPoint = currentPoint, let prePoint = previousPoint , let windowBound = UIApplication.shared.keyWindow?.bounds{
                let dx = curPoint.x - prePoint.x
                let dy = curPoint.y - prePoint.y
                
                let stateHeight = UIApplication.shared.statusBarFrame.size.height
                var newCenter = CGPoint.init(x: center.x + dx, y: center.y + dy)
                
                //限制不能超过父视图边界
                newCenter.x = max(self.frame.size.width/2, newCenter.x)
                newCenter.x = min(newCenter.x, windowBound.size.width - self.frame.size.width/2)
                
                newCenter.y = max(self.frame.size.height/2 + stateHeight,  newCenter.y)
                newCenter.y = min(newCenter.y, windowBound.size.height - self.frame.size.height/2)
                
                center = newCenter
            }
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        endTouch(point: touches.first?.location(in: UIApplication.shared.keyWindow) ?? CGPoint.init())
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        endTouch(point: touches.first?.location(in: UIApplication.shared.keyWindow) ?? CGPoint.init())
    }
    
    func endTouch(point:CGPoint) {
        if zoomOut {
            var newFrame = frame
            
            let screenWidth = UIScreen.main.bounds.size.width
            let screenHeight = UIScreen.main.bounds.size.height
            
            /// 状态栏高度
            let stateHeight = UIApplication.shared.statusBarFrame.size.height
            
            /// 如果是iPhone X时获取底部距离
            let iphonexBottomHeight : CGFloat = UIDevice.isIphoneX() ? 34.00 : 0.00
            
            if point.x > screenWidth / 2 {
                newFrame.origin.x = screenWidth - newFrame.size.width - margin
            } else {
                newFrame.origin.x = margin
            }
            
            if newFrame.origin.y > (screenHeight - iphonexBottomHeight - newFrame.size.height - margin) {
                newFrame.origin.y = screenHeight - iphonexBottomHeight - newFrame.size.height - margin
            } else if newFrame.origin.y < stateHeight {
                newFrame.origin.y = stateHeight
            }
            
            UIView.animate(withDuration: 0.25) {
                self.frame = newFrame
            }
        }
    }
    
    @objc func ViewTappedNew() {
        delegate?.clickeTappedFloatView()
    }
}
