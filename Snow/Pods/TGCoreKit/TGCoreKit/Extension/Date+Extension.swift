//
//  Date+Extension.swift
//  TGCoreKit
//
//  Created by kim on 2024/8/15.
//

import Foundation


// MARK: - 扩展属性
public extension Date {
    // 当前时间戳
    static var timestamp: Int64 {
        Int64(Date().timeIntervalSince1970 * 1000)
    }
}

// MARK: - 格式转换
public extension Date {
    // 指定时间格式转换
    func dateString(with dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
