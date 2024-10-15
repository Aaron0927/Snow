//
//  UITabBar+Extension.swift
//  Snow
//
//  Created by kim on 2024/7/30.
//

import UIKit

extension UITabBar {
    /**
     UITabBar 子控件结构
     1.为选中状态
     UITabBarButton
        |-UIVisualEffectView
            |-_UIVisualEffectContentView _
                |-UITabBarSwappableImageView
                |-UITabBarButtonLabel
     
     2.选中状态
     UITabBarButton
        |-UIVisualEffectView
            |-_UIVisualEffectContentView _
        |-UITabBarSwappableImageView
        |-UITabBarButtonLabel
     */
    
    // tabbar 上显示图片的控件
    var tabBarSwappableImageViews: [UIImageView] {
        return getViews(for: "UITabBarSwappableImageView", in: self)
    }
    
    // tabbar 上显示文字的控件
    var titleLabels: [UILabel] {
        return getViews(for: "UITabBarButtonLabel", in: self)
    }
    
    
    private func getViews<T: UIView>(for className: String, in v: UIView) -> [T] {
        var views = [T]()
        for subView in v.subviews {
            if subView.isKind(of: NSClassFromString(className)!) {
                // 记录下来
                if let view = subView as? T {
                    views.append(view)
                }
            }
            // 递归调用
            views.append(contentsOf: getViews(for: className, in: subView) as [T])
        }
        return views
    }
}

extension UIView {
    // 获取当前控件的父控件 UITabBarButton
    func superviewOfTabBarButton() -> UIView? {
        var superView = self.superview
        while (superView != nil) {
            if superView!.isKind(of: NSClassFromString("UITabBarButton")!) {
                return superView
            }
            superView = superView?.superview
        }
        return nil
    }
}
