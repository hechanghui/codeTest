//
//  Date+Apptools.swift
//  DoctorOnCloud
//
//  Created by 何昌辉 on 2021/3/20.
//



import UIKit

extension Date {
    /// 获取当前 秒级 时间戳 - 10位
    static public var timeStamp : String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    /// 获取当前 毫秒级 时间戳 - 13位
    static public var milliStamp : String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    

    static public func nowTimeStamp(format:String = "yyyy-MM-dd HH:mm") -> String {
  
        let date = Date.init()
        let dateFormatte = DateFormatter()
        dateFormatte.locale = Locale.init(identifier: "zh_Hans_CN")
        dateFormatte.dateFormat = format
        return dateFormatte.string(from: date)
    }
    
    
    //时间戳转成字符串 10位
    static public func formatTimeStamp(time:Int ,format:String = "yyyy-MM-dd HH:mm") -> String {
        let timeInterval = TimeInterval(time)
        let date = Date.init(timeIntervalSince1970: timeInterval)
        let dateFormatte = DateFormatter()
        dateFormatte.locale = Locale.init(identifier: "zh_Hans_CN")
        dateFormatte.dateFormat = format
        return dateFormatte.string(from: date)
    }
    //时间戳转成字符串 13位
    static public func formatTimeMillinStamp(time:Int ,format:String = "yyyy-MM-dd HH:mm") -> String {
        let timeInterval = TimeInterval(time / 1000)
        let date = Date.init(timeIntervalSince1970: timeInterval)
        let dateFormatte = DateFormatter()
        dateFormatte.locale = Locale.init(identifier: "zh_Hans_CN")
        dateFormatte.dateFormat = format
        return dateFormatte.string(from: date)
    }
    //毫秒转时长
    static public func secondsToHoursMinutesSeconds (seconds : Int64) -> (String) {
        let hours = seconds / 1000 / 3600
        let minuter = seconds / 1000 % 3600 / 60
        let seconds = (seconds / 1000 % 3600) % 60
        var string = ""
        var minuterstring = ""
        var secondsSting = ""
        if minuter < 10{
            minuterstring = "0\(minuter)"
        }else{
            minuterstring = "\(minuter)"
        }
        if seconds < 10{
            secondsSting = "0\(seconds)"
        }else{
            secondsSting = "\(seconds)"
        }
        if hours != 0 {
            string = "\(hours):\(minuterstring):\(secondsSting)"
        }else{
            string = "\(minuterstring):\(secondsSting)"
        }
        return string

    }
    
    
    
    //字符串转date
    static public func timeStrChangeDate(timeStr: String?, dateFormat:String? = nil) -> Date? {
        if timeStr == nil {
            return nil
        }
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        format.locale = Locale.init(identifier: "zh_Hans_CN")

        if dateFormat == nil {
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            format.dateFormat = dateFormat
        }
        let date = format.date(from: timeStr!)
        return date
    }
    
    //字符串转时间戳
    static public func timeStrChangeTotimeInterval(timeStr: String?, dateFormat:String? = nil) -> String {
        if timeStr == nil {
            return ""
        }
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        format.locale = Locale.init(identifier: "zh_Hans_CN")

        if dateFormat == nil {
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            format.dateFormat = dateFormat
        }
        let date = format.date(from: timeStr!)
        return String(CLongLong(round(date!.timeIntervalSince1970*1000)))
    }

    
    /// 获取相隔年份的date时间
    static public func getDateWithYear(date: Date = Date.init(), distanceYear: Int) -> Date{
        let calendar = Calendar.init(identifier: .gregorian)
        var comps = DateComponents.init()
        comps.year = distanceYear
        comps.month = 0
        comps.day = 0
        let disDate = calendar.date(byAdding: comps, to: date)
        return disDate ?? Date.init()
    }
    
    //比较两个时间字符串
    static public func compareDateString(dateString: String, otherDateString: String) -> ComparisonResult {
        let format = DateFormatter.init()
        format.locale = Locale.init(identifier: "zh_Hans_CN")

        format.dateFormat = "yyyy-MM-dd"
        let date1 = format.date(from: dateString)
        let date2 = format.date(from: otherDateString)
        if date1 != nil && date1 != nil {
           return date1!.compare(date2!)
        }
        return .orderedAscending
    }
    
    //时间戳转成字符串 10位
    public func formatTimeStamp(format:String = "yyyy-MM-dd HH:mm") -> String {
        let dateFormatte = DateFormatter()
        dateFormatte.locale = Locale.init(identifier: "zh_Hans_CN")
        dateFormatte.dateFormat = format
        return dateFormatte.string(from: self)
    }
    
    
    /// 获取当前时间的对象(号、周，月等信息)
    static func getDayNumber(date: Date = Date()) -> DateComponents {
        let nowDate = Date()
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.year, .month, .day, .weekday], from: nowDate)
        return comp
    }
    
    /// 获取某一天所在的周一和周日
    static func getWeekTime(_ dateStr: String = "yyyy-MM-dd") -> Array<String> {
          let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "zh_Hans_CN")

          dateFormatter.dateFormat = dateStr
//          let nowDate = dateFormatter.date(from: dateStr)
          let nowDate = Date()
          let calendar = Calendar.current
          let comp = calendar.dateComponents([.year, .month, .day, .weekday], from: nowDate)
            
          // 获取今天是周几
          let weekDay = comp.weekday
          // 获取几天是几号
          let day = comp.day
            
          // 计算当前日期和本周的星期一和星期天相差天数
          var firstDiff: Int
          var lastDiff: Int
          // weekDay = 1;
          if (weekDay == 1) {
              firstDiff = -6;
              lastDiff = 0;
          } else {
              firstDiff = calendar.firstWeekday - weekDay! + 1
              lastDiff = 8 - weekDay!
          }
        
        var weekArr = [String]()

        // 在当前日期(去掉时分秒)基础上加上差的天数
        let startIndex = day! + firstDiff
        let endIndex = day! + lastDiff
        for i in startIndex...endIndex{
            var dayComp = calendar.dateComponents([.year, .month, .day], from: nowDate)
            dayComp.day =  i
            let dayOfWeek = calendar.date(from: dayComp)
            let lastDay = dateFormatter.string(from: dayOfWeek!)
            weekArr.append(lastDay)
        }
         
        
          return weekArr;
      }

    
    
    
    
    static func dateComponents(from: Date, to: Date) -> DateComponents {
        
//        let date1Str = "2016/09/30"
//        let date2Str = "2021/12/01"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy/MM/dd"
//        let date1 = dateFormatter.date(from: date1Str)
//        let date2 = dateFormatter.date(from: date2Str)

        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: from, to: to)

        return components
        
        
    }
    
    

}
