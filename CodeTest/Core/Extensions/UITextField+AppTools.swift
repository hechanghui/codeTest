//
//  UITextField+AppTools.swift
//  AngelDoctor
//
//  Created by dsq on 2021/4/26.
//

import UIKit


extension UITextField{
    ///限制文本的长度
    public func textFieldLimitLength(maxLength: Int, isContainEmoji: Bool = true) {
        let toBeString = self.text!
        let lang = UIApplication.shared.textInputMode?.primaryLanguage //键盘输入模式
        if lang == "zh-Hans" || lang == "zh-Hant" {
            //简体中文输入，包括简体拼音，健体五笔，简体手写
            //获取高亮部分
            guard let selectedRange = self.markedTextRange, let _ = self.position(from: selectedRange.start, offset: 0) else {
                if toBeString.count > maxLength {
                    self.text = toBeString.sub(to: maxLength)
                }
                return
            }
//
//            if position != nil {
//                if toBeString.count > maxLength {
//                    self.text = toBeString.sub(to: maxLength)
//                }
//            }else{
//
//            }
        }else{
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if toBeString.count > maxLength {
                self.text = toBeString.sub(to: maxLength)
                

            }
            
            if isContainEmoji {
                self.text = self.filterEmoji(text: self.text!)
            }
        }
        
        
        
    }
    
    
    /// 过滤表情
    private func filterEmoji(text: String) -> String{
        let pattern = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        do {
            let regex = try NSRegularExpression.init(pattern: pattern, options: .caseInsensitive)
            let modifiedString = regex.stringByReplacingMatches(in: text, options: .reportProgress, range: NSRange(location: 0, length: text.count), withTemplate: "")
            return modifiedString
        } catch _ {
            return ""
        }

    }

  
    
}




