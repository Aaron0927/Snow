//
//  TGPageProtocol.swift
//  Snow
//
//  Created by kim on 2024/8/26.
//

import UIKit

// 定义容器视图协议
protocol TGPageControllerDelegate where Self: UIViewController {
    // 头部视图
    func topViewForPageController(_ pageController: TGPageController) -> UIView
    
    // 控制器数组
    func controllersForPageController(_ pageController: TGPageController) -> [TGPageContent]
}


// 子视图应该实现的协议
protocol TGPageContent where Self: UIViewController {
    var canScroll: Bool { set get }
    var scrollView: UIScrollView? { get }
    
    // scrollView 滚动回调 -> 在子视图的 scrollViewDidScroll 方法中主动调用
    var scrollViewDidScroll: ((UIScrollView) -> Void)? { set get }
}
