//
//  UIViewController+Extensions.swift
//  Snow
//
//  Created by kim on 2024/7/16.
//

import UIKit

extension UIViewController {
    // 获取导航栏高度
    func getNavBarAndStatusBarHeight() -> CGFloat {
        // 获取整个导航栏高度（状态栏高度 + 导航栏高度）
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let statusBarHeight = getStatusBarHeight()
        let totalNavBarHeight = navigationBarHeight + statusBarHeight
        
        // 获取 safe area 顶部 inset
        let safeAreaTopInset = view.safeAreaInsets.top
        
        // 计算 safe area 的导航栏高度
        let safeAreaNavBarHeight = totalNavBarHeight - safeAreaTopInset
        
        return safeAreaNavBarHeight
    }
    
    // 获取导航栏高度
    func getNavigationBarHeight() -> CGFloat {
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        return navigationBarHeight
    }
    
    // 获取状态栏高度
    func getStatusBarHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
}

