//
//  Button+AppTools.swift
//  AngelDoctor
//
//  Created by dsq on 2021/4/6.
//

import UIKit

var expandSizeKey = "expandSizeKey"

extension UIButton{
    
    //MARK: UIButton 扩大点击范围
    func expandSize(size: CGFloat) {
        objc_setAssociatedObject(self, &expandSizeKey,size, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
    
    private func expandRect() -> CGRect {
        let expandSize = objc_getAssociatedObject(self, &expandSizeKey)
        if expandSize != nil {
            return CGRect(x: bounds.origin.x - (expandSize as! CGFloat), y: bounds.origin.y - (expandSize as! CGFloat), width: bounds.size.width + 2*(expandSize as! CGFloat), height: bounds.size.height + 2*(expandSize as! CGFloat))
        }else{
            return bounds;
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRect = expandRect()
        if (buttonRect.equalTo(bounds)) {
            return super.point(inside: point, with: event)
        }else{
            return buttonRect.contains(point)
        }
        
    }
    
    //bt的动画效果1 （放大缩小）
    func startAnimatingType1() {
        let k = CAKeyframeAnimation(keyPath: "transform.scale")
        k.values = [ 1.0,1.5,1.0]
       k.keyTimes = [0.0, 0.1, 0.2]
       k.calculationMode = .linear
       k.repeatCount = 1
       k.duration = 2.0
       self.imageView?.layer.add(k, forKey: nil)
        
    }
}
