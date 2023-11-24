//
//  Image+AppTools.swift
//   
//
//  Created by  hech on 2021/1/7.
//

import UIKit


extension UIImage {
    //渐变类型
    enum GradientType {
        case topToBottom
        case leftToRight
        case topLeftToBottomRight
        case topRightToBottomLeft
    }
    /// 生成渐变图片
    /// - Parameters:
    ///   - type: 渐变方向
    ///   - colors: 过度颜色
    ///   - locations: 每个颜色渐变的位置， 0-1之间
    ///   - size: 图片大小
    convenience init(colors: [UIColor], gradientType type: GradientType, locations: [CGFloat], size: CGSize) {
        assert(colors.count == locations.count, "渐变数组与颜色位置数组 count 不一致")
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = colors.compactMap { (color) -> CGColor in
            return color.cgColor
        }
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: locations) else {
            self.init()
            return
        }
        switch type {
        case .leftToRight:
            context?.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: 0), options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
        case .topToBottom:
            context?.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
        case .topLeftToBottomRight:
            context?.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: size.height), options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
        case .topRightToBottomLeft:
            context?.drawLinearGradient(gradient, start: CGPoint(x: size.width, y: 0), end: CGPoint(x: 0, y: size.height), options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
        }
        if let newImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage {
            self.init(cgImage: newImage)
        }else {
            self.init()
        }
        context?.restoreGState()
        UIGraphicsEndImageContext()
    }
    
    
    /// 根据颜色创建图片
    class func imageWithColor(_ color: UIColor) -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: 3.0, height: 3.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
    func smartCompress() -> Data? {
        /** 仿微信算法 **/
        var tempImage = self
        let width:Int = Int(self.size.width)
        let height:Int = Int(self.size.height)
        var updateWidth = width
        var updateHeight = height
        let longSide = max(width, height)
        let shortSide = min(width, height)
        let scale:CGFloat = CGFloat(CGFloat(shortSide) / CGFloat(longSide))
        
        // 大小压缩
        if shortSide < 1080 || longSide < 1080 { // 如果宽高任何一边都小于 1080
            updateWidth = width
            updateHeight = height
        } else { // 如果宽高都大于 1080
            if width < height { // 说明短边是宽
                updateWidth = 1080
                updateHeight = Int(1080 / scale)
            } else { // 说明短边是高
                updateWidth = Int(1080 / scale)
                updateHeight = 1080
            }
        }
        
        let size: CGSize = CGSize(width: updateWidth, height: updateHeight)
        UIGraphicsBeginImageContext(size)
        tempImage.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        if let image:UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            tempImage = image
        }
        UIGraphicsEndImageContext()
        let resultData:Data? = tempImage.jpegData(compressionQuality:0.5)//质量压缩一半
        return resultData
    }
}

