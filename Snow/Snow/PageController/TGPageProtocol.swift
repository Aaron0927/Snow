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
    func topViewForPageController(_ pageController: TGPageController) -> UIView?
    // 头部视图高度
    func topViewHeightForPageController(_ pageController: TGPageController) -> CGFloat
    
    // 标题数组
    func pageTitlesForPageController(_ pageController: TGPageController) -> [String]
    // 标题数组高度, 默认 50
    func pageTitleViewHeightForPageController(_ pageController: TGPageController) -> CGFloat
    
    // 控制器数组
    func controllersForPageController(_ pageController: TGPageController) -> [TGPageContentController]
}

extension TGPageControllerDelegate {
    // 标题数组高度
    func pageTitleViewHeightForPageController(_ pageController: TGPageController) -> CGFloat {
        return 50
    }
}


// 子视图应该实现的协议
protocol TGPageContentController where Self: UIViewController {
    var canScroll: Bool { set get }
    var scrollView: UIScrollView? { get }
    
    // scrollView 滚动回调 -> 在子视图的 scrollViewDidScroll 方法中主动调用
    var scrollViewDidScroll: ((UIScrollView) -> Void)? { set get }
}
