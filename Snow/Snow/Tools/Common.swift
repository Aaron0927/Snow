//
//  Common.swift
//  Snow
//
//  Created by kim on 2024/8/1.
//

import UIKit


// 状态栏高度
var kStatusBarH: CGFloat {
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}

// 导航栏高度
var kNavBarH: CGFloat {
    UINavigationController().navigationBar.frame.size.height
}

// tabbar高度
var kTabBarH: CGFloat {
    UITabBar.appearance().frame.size.height
}

// 屏幕宽度
var kScreenW: CGFloat {
    UIScreen.main.bounds.size.width
}

// 屏幕高度
var kScreenH: CGFloat {
    UIScreen.main.bounds.size.height
}
