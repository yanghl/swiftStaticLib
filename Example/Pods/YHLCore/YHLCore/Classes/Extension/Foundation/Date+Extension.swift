//
//  Date+Extension.swift
//  GWUtilCore
//
//  Created by yan on 2020/1/17.
//

import Foundation
import SwifterSwift

//MARK: - GW项目常用日期格式
public enum GWCommonDateFormateType: String {
    case typeOne = "yyyyMMddHHmmss"
    case typeTwo = "yyyy-MM-dd HH:mm:ss"
    case typeThree = "yyyyMMddHH:mm:ss"
    case typeFour = "yyyyMMdd"
    case typeFive = "yyyy年MM月dd日"
    case typeSix = "yyyy-MM-dd"
    case typeSeven = "yyyy/MM/dd"
    case typeEight = "yyyy-MM-dd HH:mm"
    case typeNine = "MM-dd HH:mm"
    case typeTen = "HHmmss"
    case typeEleven = "HH:mm:ss"
    case typeTwelve = "HH:mm"
    case typeThirteen = "yyyy-MM"
    case typeFourteen = "yyyy年MM月"
    case typeFifteen = "MM-dd"
}

//MARK: - 获取日期时间的各个组成成分
//Date <-> DateComponents,中间的桥梁就是 Calendar（日历），而Calendar（必须要设置TimeZone时区）
public extension Date {
    
    /// 这个月有几天
    var daysInMonth: Int {
        //公立日历
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self)
        return range.length
    }
}

//MARK: - 特殊化定制
public extension Date{
    
    /// 与当前时间比较，可用于发帖、账单
    /// - Parameter str: 刚刚(一分钟以内),X分钟以前（1个小时以内）,X小时前（当天）,昨天 HH:mm(昨天),MM-dd HH-mm (一年内),yyyy-MM-dd HH:mm (更早时间)
    static func compareCurrentTime(str: String, formatStr: String) -> String {
        let d = str.date(withFormat: formatStr)
        var result = ""
        if let date = d {
            if date.isInToday {
                let currentDate = Date()
                let interval = currentDate.timeIntervalSince(date)
                if interval < 60 {
                    result = "刚刚"
                }
                else if interval < (60 * 60){
                    result = "\(Int(interval/60))分钟前"
                }
                else{
                    result = "\(Int(interval/(60 * 60)))小时前"
                }
            }
            else if date.isInYesterday {
                
                result = "昨天 " + date.string(withFormat: GWCommonDateFormateType.typeEleven.rawValue)
            }
            else if date.isInCurrentYear {
                result = date.string(withFormat: GWCommonDateFormateType.typeNine.rawValue)
            }
            else {
                result = date.string(withFormat: GWCommonDateFormateType.typeEight.rawValue)
            }
        }
        return result
    }
}
