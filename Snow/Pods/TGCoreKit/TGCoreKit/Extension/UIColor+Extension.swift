//
//  UIColor+Extension.swift
//  TGCoreKit
//
//  Created by kim on 2024/8/14.
//

import UIKit

// MARK: - 增加初始化方法
@objc public extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        let components = (
            R: CGFloat((hex >> 16) & 0xFF) / 255.0,
            G: CGFloat((hex >> 08) & 0xFF) / 255.0,
            B: CGFloat((hex >> 00) & 0xFF) / 255.0
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
    
    // 为方便起见，仅处理 6 位 和 8 位字符串形式
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if hexString.hasPrefix("#") {
            hexString = String(hexString.dropFirst()) // 去掉 #
        }
        
        if hexString.hasPrefix("0x") {
            hexString = String(hexString.dropFirst(2)) // 去掉 0x
        }
        
        // 获取 alpha
        var alpha: UInt32 = 255
        if hexString.count == 8 {
            let lastTwo = String(hexString.suffix(2)) // 获取最后两位
            hexString = String(hexString.dropLast(2)) // 移除最后两位
            Scanner(string: lastTwo).scanHexInt32(&alpha)
        }
        
        
        // 获取 RGB
        var color: UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&color)
        
        let components = (
            R: CGFloat((color >> 16) & 0xFF) / 255.0,
            G: CGFloat((color >> 08) & 0xFF) / 255.0,
            B: CGFloat((color >> 00) & 0xFF) / 255.0
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: CGFloat(alpha) / 255.0)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    var randomColor: UIColor {
        UIColor(r: CGFloat.random(in: 0..<255), g: CGFloat.random(in: 0..<255), b: CGFloat.random(in: 0..<255))
    }
}

// MARK: - 定义设计图颜色
@objc public extension UIColor {
    // 行情图表相关颜色
    static var app_red: UIColor { UIColor(hex: "#F54346") }
    static var app_green: UIColor { UIColor(hex: "#16BA70") }
    static var app_blue: UIColor { UIColor(hex: "#308FFF") }
    static var app_gray: UIColor { UIColor(hex: "0x999999") }
    
    // 文本颜色
    static var app_text_primary_dark: UIColor { UIColor(hex: "#333333") }
    
    // 背景颜色
    static var app_bg_dark: UIColor { UIColor(hex: "0x141a26") }
    
    // 边框颜色
    
    // 分割线颜色
    
}
