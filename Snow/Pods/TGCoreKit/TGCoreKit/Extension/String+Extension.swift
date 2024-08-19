//
//  String+Extension.swift
//  TGCoreKit
//
//  Created by kim on 2024/8/15.
//

import Foundation

// MARK: - 时间格式处理
public extension String {
    /// 字符串时间格式转换
    /// - Parameters:
    ///   - fromFormatter: 当前字符串时间格式
    ///   - toFormatter: 目标字符串时间格式
    /// - Returns: 返回转换后的字符串
    func convert(from fromFormatter: String, to toFormatter: String) -> String? {
        let fromDateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = fromFormatter
        guard let date = fromDateFormatter.date(from: self) else {
            return nil
        }
        
        let toDateFormatter = DateFormatter()
        toDateFormatter.dateFormat = toFormatter
        return toDateFormatter.string(from: date)
    }
    
    // 获取指定格式时间
    func toDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}

// MARK: - 正则相关
public extension String {
    private func valid(_ pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        let regular = try? NSRegularExpression(pattern: pattern, options: options)
        let matchs = regular?.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        return matchs?.count ?? 0 > 0
    }
    
    // 邮箱验证
    var isEmail: Bool {
        let pattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9]+(\\.[A-Za-z]{2,})+$"
        return valid(pattern)
    }
    
    // 内地手机号码验证
    var isChinaPhone: Bool {
        let pattern = "^1[0-9]{2}\\s*[0-9]{4}\\s*[0-9]{4}$"
        return valid(pattern, options: [.caseInsensitive, .allowCommentsAndWhitespace])
    }
    
    // 香港手机号码验证
    var isHKPhone: Bool {
        let pattern = "^[5689]\\d{7}$"
        return valid(pattern)
    }
    
    // 是否为数字
    var isNumber: Bool {
        let pattern = "^[0-9]+$"
        return valid(pattern)
    }
    
    // 是否为字母
    var isCharacter: Bool {
        let pattern = "^[a-zA-Z]+$"
        return valid(pattern)
    }
    
    // 是否为数字或字母
    var isCharacterOrNumber: Bool {
        let pattern = "^[A-Za-z0-9]+$"
        return valid(pattern)
    }
    
    // 是否为中文
    var isChinese: Bool {
        let pattern = "^[\\u4e00-\\u9fa5]+$"
        return valid(pattern)
    }
    
    
}


// MARK: - 金额格式化相关
public extension String {
    // 千分位字符串转 Number 类型
    func toNumber() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal // 设置格式为千分位
        numberFormatter.locale = Locale.current // 使用当前区域设置
        
        // 使用 NumberFormatter 将字符串转换为 NSNumber
        if let number = numberFormatter.number(from: self) {
            return number.doubleValue
        }
        return nil
    }
    
    // 千分位字符串转数字类型
    func number() -> NSNumber? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal // 设置格式为千分位
        numberFormatter.groupingSeparator = "," // 设置千分位分隔符
        numberFormatter.decimalSeparator = "." // 小数点格式
        
        return numberFormatter.number(from: self)
    }
    
    // Number 类型转千分位字符串
    static func thousandFormat(_ num: any Numeric, fractionDigits: Int = 0) -> String? {
        // 将 Numeric 转换为 NSNumber
        let number = num as? NSNumber ?? NSNumber(value: 0)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal // 设置格式为千分位
        numberFormatter.groupingSeparator = "," // 设置千分位分隔符
        numberFormatter.minimumFractionDigits = fractionDigits // 小数位最小个数
        numberFormatter.maximumFractionDigits = fractionDigits // 小数位最大个数
        
        var format = "#,##0.\(String(repeating: "0", count: fractionDigits))"
        if fractionDigits == 0 {
            format = "#,##0"
        }
        // 设置正数格式
        numberFormatter.positiveFormat = format
        // 设置负数格式
        numberFormatter.negativeFormat = "-\(format)"
        
        // 使用 NumberFormatter 将数字转换为字符串
        return numberFormatter.string(for: number)
    }
}

public extension Numeric {
    // 千分位格式化
    func thousandFormatString(fractionDigits: Int = 0) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.minimumFractionDigits = fractionDigits
        numberFormatter.maximumFractionDigits = fractionDigits
        
        var format = "#,##0.\(String(repeating: "0", count: fractionDigits))"
        if fractionDigits == 0 {
            format = "#,##0"
        }
        // 设置正数格式
        numberFormatter.positiveFormat = format
        // 设置负数格式
        numberFormatter.negativeFormat = "-\(format)"
        
        let number = self as? NSNumber ?? NSNumber(value: 0)
        
        return numberFormatter.string(from: number)
    }
}
 
