//
//  Common.swift
//  TGCoreKit
//
//  Created by kim on 2024/8/14.
//

import UIKit

// MARK: - 设备相关尺寸
// 屏幕宽度
public var kScreenW: CGFloat {
    UIScreen.main.bounds.size.width
}

// 屏幕高度
public var kScreenH: CGFloat {
    UIScreen.main.bounds.size.height
}

// 状态栏高度
public var kStatusBarH: CGFloat {
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}

// 导航栏高度
public var kNavigationBarH: CGFloat {
    UINavigationController().navigationBar.frame.size.height
}

// tabbar高度
public var kTabBarH: CGFloat {
    UITabBar.appearance().frame.size.height
}

// 安全区域
public var kSafeAreaInset: UIEdgeInsets {
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.keyWindow
        return window?.safeAreaInsets ?? .zero
    } else {
        return UIEdgeInsets.zero
    }
}

// MARK: - 系统信息相关
// 应用版本号
public var appVersion: String? {
    guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
        return nil
    }
    return version
}
// 应用build号
public var appBuildVersion: String? {
    guard let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
        return nil
    }
    return version
}

// 设备版本
public let deviceVersion: String = UIDevice.current.systemVersion
// 设备名称
public let deviceName: String = UIDevice.current.systemName
// 设备识别码
public let deviceUUID: String = UIDevice.current.identifierForVendor?.uuidString ?? ""



// MARK: - 设计通用尺寸
// 分割线高度
public let kLineH: CGFloat = 0.5

// 设计图基准线 -> 只用于间隔
private let d_baseLine: CGFloat = 2.0
public func d_padding(_ multiple: Int) -> CGFloat {
    d_baseLine * CGFloat(multiple)
}

public let padding_1: UIEdgeInsets = UIEdgeInsets(top: d_padding(1), left: d_padding(1), bottom: d_padding(1), right: d_padding(1))
public let pt_1: CGFloat = padding_1.top
public let pb_1: CGFloat = padding_1.bottom
public let pl_1: CGFloat = padding_1.left
public let pr_1: CGFloat = padding_1.right


// MARK: - 设计通用字体
public func systemRegularFont(_ fontSize: CGFloat) -> UIFont {
    UIFont.systemFont(ofSize: fontSize, weight: .regular)
}

public func systemMediumFont(_ fontSize: CGFloat) -> UIFont {
    UIFont.systemFont(ofSize: fontSize, weight: .medium)
}

public func systemBoldFont(_ fontSize: CGFloat) -> UIFont {
    UIFont.systemFont(ofSize: fontSize, weight: .bold)
}

