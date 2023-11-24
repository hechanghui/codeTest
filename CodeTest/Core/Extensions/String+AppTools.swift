//
//  String+AppTools.swift
//   
//
//  Created by  hech on 2021/1/7.
//

import UIKit
import SVProgressHUD

//import Toast_Swift
extension String {
    
    //去掉空格
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }

    func showWarnToast(){
        SVProgressHUD.showWarnInfo(info: self, dismissDelay: 1)
    }
    
    func showToast(){
        SVProgressHUD.showInfo(info: self, dismissDelay: 1)
    }
    
    
    func showSuccess(){
        SVProgressHUD.showSuccess(info: self, dismissDelay: 1)
    }
   
    func showError(){
        SVProgressHUD.showError(info: self, dismissDelay: 1)
    }
    
    func showLoading(){
        SVProgressHUD.showLoading(info: self)
    }
    // MARK: 字符串转字典
    func toDictionary() -> [String: Any] {
        var result = [String: Any]()
        guard !self.isEmpty else {
            return result
        }
        
        guard let dataSelf = self.data(using: .utf8) else { return result }
        
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf, options: .mutableContainers) as? [String: Any] {
            result = dic
        }
        return result
    }
    
    //正则相关
    // MARK: 8.1、判断是否全是空白,包括空白字符和换行符号，长度为0返回true
    /// 判断是否全是空白,包括空白字符和换行符号，长度为0返回true
    public var isBlank: Bool {
        return trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == ""
    }

    // MARK: 8.2、判断是否全十进制数字，长度为0返回false
    /// 判断是否全十进制数字，长度为0返回false
    public var isDecimalDigits: Bool {
        if isEmpty {
            return false
        }
        // 去除什么的操作
        return trimmingCharacters(in: NSCharacterSet.decimalDigits) == ""
    }

    // MARK: 8.3、判断是否是整数
    /// 判断是否是整数
    public var isPureInt: Bool {
        let scan: Scanner = Scanner(string: self)
        var n: Int = 0
        return scan.scanInt(&n) && scan.isAtEnd
    }

    // MARK: 8.4、判断是否是Float,此处Float是包含Int的，即Int是特殊的Float
    /// 判断是否是Float，此处Float是包含Int的，即Int是特殊的Float
//    public var isPureFloat: Bool {
//        let scan: Scanner = Scanner(string: self)
//        var n: Float = 0.0
//        return scan.scanFloat(&n) && scan.isAtEnd
//    }

    // MARK: 8.5、判断是否全是字母，长度为0返回false
    /// 判断是否全是字母，长度为0返回false
    public var isLetters: Bool {
        if isEmpty {
            return false
        }
        return trimmingCharacters(in: NSCharacterSet.letters) == ""
    }

    // MARK: 8.6、判断是否是中文, 这里的中文不包括数字及标点符号
    /// 判断是否是中文, 这里的中文不包括数字及标点符号
    public var isChinese: Bool {
        let mobileRgex = "(^[\u{4e00}-\u{9fef}]+$)"
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileRgex)
        return checker.evaluate(with: self)
    }

    // MARK: 8.7、是否是有效昵称，即允许“中文”、“英文”、“数字”
    /// 是否是有效昵称，即允许“中文”、“英文”、“数字”
    public var isValidNickName: Bool {
        let rgex = "(^[\u{4e00}-\u{9faf}_a-zA-Z0-9]+$)"
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", rgex)
        return checker.evaluate(with: self)
    }

    // MARK: 8.8、判断是否是有效的手机号码
    /// 判断是否是有效的手机号码
    public var isValidMobile: Bool {
//        let mobileRgex = "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199)\\d{8}$"
        //判断1开头的11位
        let mobileRgex = "^1\\d{10}$"
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileRgex)
        return checker.evaluate(with: self)
    }

    // MARK: 8.9、判断是否是有效的电子邮件地址
    /// 判断是否是有效的电子邮件地址
    public var isValidEmail: Bool {
        let mobileRgex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileRgex)
        return checker.evaluate(with: self)
    }

    // MARK: 8.10、判断是否有效的身份证号码，不是太严格
    /// 判断是否有效的身份证号码，不是太严格
    public var isValidIDCardNumber: Bool {
        let mobileRgex = "^(\\d{15})|((\\d{18})(\\d|[X]))$"
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileRgex)
        return checker.evaluate(with: self)
    }
    
    /// 中文、英文、数字但不包括下划线等符号
    public var isVaildSpecialString: Bool {
        let regex = "^[\\u4E00-\\u9FA5A-Za-z0-9]+$"
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return checker.evaluate(with: self)
    }
    
    // MARK: 8.11、严格判断是否有效的身份证号码,检验了省份，生日，校验位，不过没检查市县的编码
    /// 严格判断是否有效的身份证号码,检验了省份，生日，校验位，不过没检查市县的编码
    public var isValidIDCardNumStrict: Bool {
        let str = trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let len = str.count
        if !str.isValidIDCardNumber {
            return false
        }
        // 省份代码
        let areaArray = ["11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]
        if !areaArray.contains(str.sub(to: 2)) {
            return false
        }
        var regex = NSRegularExpression()
        var numberOfMatch = 0
        var year = 0
        switch len {
        case 15:
            // 15位身份证
            // 这里年份只有两位，00被处理为闰年了，对2000年是正确的，对1900年是错误的，不过身份证是1900年的应该很少了
            year = Int(str.sub(start: 6, length: 2))!
            if isLeapYear(year: year) { // 闰年
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: .caseInsensitive)
                } catch {}
            } else {
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .caseInsensitive)
                } catch {}
            }
            numberOfMatch = regex.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, len))

            if numberOfMatch > 0 {
                return true
            } else {
                return false
            }
        case 18:
            // 18位身份证
            year = Int(str.sub(start: 6, length: 4))!
            if isLeapYear(year: year) {
                // 闰年
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch {}
            } else {
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch {}
            }
            numberOfMatch = regex.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, len))
            if numberOfMatch > 0 {
                var s = 0
                let jiaoYan = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3]
                for i in 0 ..< 17 {
                    if let d = Int(str.slice(i ..< (i + 1))) {
                        s += d * jiaoYan[i % 10]
                    } else {
                        return false
                    }
                }
                let Y = s % 11
                let JYM = "10X98765432"
                let M = JYM.sub(start: Y, length: 1)
                if M == str.sub(start: 17, length: 1) {
                   return true
                } else {
                    return false
                }
            } else {
                return false
            }
        default:
            return false
        }
    }
        
    // MARK: 8.12、校验字符串位置是否合理，并返回String.Index
    /// 校验字符串位置是否合理，并返回String.Index
    /// - Parameter original: 位置
    /// - Returns: String.Index
    public func validIndex(original: Int) -> String.Index {
        switch original {
        case ...startIndex.utf16Offset(in: self):
             return startIndex
        case endIndex.utf16Offset(in: self)...:
             return endIndex
        default:
             return index(startIndex, offsetBy: original)
        }
    }

    // MARK: 8.13、隐藏手机号中间的几位
    /// 隐藏手机号中间的几位
    /// - Parameter combine: 隐藏的字符串(替换的类型)
    /// - Returns: 返回隐藏的手机号
    public func hidePhone(combine: String = "****") -> String {
         if self.count >= 11 {
            let pre = self.sub(start: 0, length: 3)
            let post = self.sub(start: 7, length: 4)
            return pre + combine + post
        } else {
            return self
        }
    }
     

    // MARK:- private 方法
    // MARK: 是否是闰年
    /// 是否是闰年
    /// - Parameter year: 年份
    /// - Returns: 返回是否是闰年
    private func isLeapYear(year: Int) -> Bool {
        if year % 400 == 0 {
            return true
        } else if year % 100 == 0 {
            return false
        } else if year % 4 == 0 {
            return true
        } else {
            return false
        }
    }
    
    
    // MARK: 9.1、截取字符串从开始到 index
    /// 截取字符串从开始到 index
    /// - Parameter index: 截取到的位置
    /// - Returns: 截取后的字符串
    public func sub(to index: Int) -> String {
        let end_Index = validIndex(original: index)
        return String(self[startIndex ..< end_Index])
    }

    // MARK: 9.2、截取字符串从index到结束
    /// 截取字符串从index到结束
   /// - Parameter index: 截取结束的位置
    /// - Returns: 截取后的字符串
    public func sub(from index: Int) -> String {
        let start_index = validIndex(original: index)
        return String(self[start_index ..< endIndex])
    }

    // MARK: 9.3、获取指定位置和长度的字符串
    /// 获取指定位置和大小的字符串
    /// - Parameters:
    ///   - start: 开始位置
    ///   - length: 长度
    /// - Returns: 截取后的字符串
    public func sub(start: Int, length: Int = -1) -> String {
        var len = length
        if len == -1 {
            len = count - start
        }
        let st = index(startIndex, offsetBy: start)
        let en = index(st, offsetBy: len)
        let range = st ..< en
        return String(self[range]) // .substring(with:range)
    }
    
    // MARK: 9.4、切割字符串(区间范围 前闭后开)
    /**
     https://blog.csdn.net/wang631106979/article/details/54098910
     CountableClosedRange：可数的闭区间，如 0...2
     CountableRange：可数的开区间，如 0..<2
     ClosedRange：不可数的闭区间，如 0.1...2.1
     Range：不可数的开居间，如 0.1..<2.1
     */
    /// 切割字符串(区间范围 前闭后开)
    /// - Parameter range: 范围
    /// - Returns: 切割后的字符串
    public func slice(_ range: CountableRange<Int>) -> String { // 如 sliceString(2..<6)
        /**
         upperBound（上界）
         lowerBound（下界）
         */
        let startIndex = validIndex(original: range.lowerBound)
        let endIndex = validIndex(original: range.upperBound)
        guard startIndex < endIndex else {
            return ""
        }
        return String(self[startIndex ..< endIndex])
    }

    ///截图时间戳，默认年月日时间
    func dateStringSubToYMD(index: Int = 10) -> String{
        if self.count > index {
            return self.sub(to: index)
        }
        return self
    }
    
    
    
    ///
    func timeStrChangeTotimeInterval(_ dateFormat:String? = "yyyy-MM-dd HH:mm") -> String {
        if self.isEmpty {
            return ""
        }

        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        format.locale = Locale.init(identifier: "zh_Hans_CN")

        if dateFormat == nil {
            format.dateFormat = "yyyy-MM-dd HH:mm"
        }else{
            format.dateFormat = dateFormat
        }
        
        let date = format.date(from: self)
        if date == nil {
            return ""
        }
        return String(date!.timeIntervalSince1970)
    }

    func timeStrChangeToMilliStampInterval(_ dateFormat:String? = "yyyy-MM-dd HH:mm") -> String {
        if self.isEmpty {
            return ""
        }
        let format = DateFormatter.init()
        format.locale = Locale.init(identifier: "zh_Hans_CN")

        format.dateStyle = .medium
        format.timeStyle = .short
        if dateFormat == nil {
            format.dateFormat = "yyyy-MM-dd HH:mm"
        }else{
            format.dateFormat = dateFormat
        }
        let date = format.date(from: self)
        return String(Int(date!.timeIntervalSince1970 * 1000))
    }
    
   
    
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //随机数字母和数字
    static func randomString(length: Int = 32) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }

    
    
    var containsEmoji: Bool {
        return contains{ $0.isEmoji}
    }
    
    /// 打电话
    func callMobile() -> Void {
        let temStr = self.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "")
        guard temStr.count > 0 else {
            SVProgressHUD.showError(info: "号码不存在", dismissDelay: 1)
            return
        }
        let tel = "tel://"+temStr
        let url = URL(string: tel)!
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:]) { (isCall) in
                }
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    
    //计算字符串的size
    func textSize(font : UIFont , maxSize : CGSize) -> CGSize{
        return self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
    }

    func nsRange(from range: Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from),
                               utf16view.distance(from: from, to: to))
        } else {
            return NSMakeRange(0, 0)
        }
    
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
}

extension Character {
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else {
            return false
        }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    var isCombinedIntoEmoji: Bool {
        unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
    }
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

