//
//  ColorAppTools.swift
//   
//
//  Created by  hech on 2021/1/7.
//


import Foundation
import UIKit

extension UIColor {
    
    /// - Parameters:
    /// - hexString: 以"#"或"0x"开头, 后面跟随6位(或3位)16进制数字 表示RGB分量值的字符串
    /// - alpha: 不透明度 (0 ~ 1)
    /// - return: 颜色对象
    public static func color(hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue:  CGFloat = 0.0
        var cString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        guard cString.hasPrefix("0X") || cString.hasPrefix("#") else {
            debugPrint("Invalid RGB hex string, missing '#' or '0x' as prefix.")
            return UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }

        if cString.hasPrefix("0X") {
            cString = String(cString.suffix(from: cString.index(cString.startIndex, offsetBy: 2)))
        } else if cString.hasPrefix("#") {
            cString = String(cString.suffix(from: cString.index(cString.startIndex, offsetBy: 1)))
        }

        let scanner = Scanner(string: cString)
        var hexValue: CUnsignedLongLong = 0
        guard scanner.scanHexInt64(&hexValue) else {
            debugPrint("Scan hex error.")
            return UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        }

        switch (cString.count) {
        case 3:
            red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
            green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
            blue  = CGFloat(hexValue & 0x00F)              / 15.0

        case 6:
            red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
            green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
            blue  = CGFloat(hexValue & 0x0000FF)           / 255.0

        default:
            red = 0.0; green = 0.0; blue = 1.0
            NSLog("Invalid RGB hex string, number of characters after '#' or '0x' should be either 3 or 6.")
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// 颜色
    ///  遍历构造器
    /// - Parameters:
    ///   - red: 红色值(0 -- 255)
    ///   - blue: 蓝色值(0 -- 255)
    ///   - green: 绿色值(0 -- 255)
    ///   - alpha: 透明度(0 -- 1)
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(r: r, g: g, b: b, a: 1)
    }
    
    
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

