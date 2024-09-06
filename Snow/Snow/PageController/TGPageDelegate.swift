//
//  TGPageDelegate.swift
//  Snow
//
//  Created by kim on 2024/8/26.
//

import UIKit

// MARK: - 容器视图协议
protocol TGPageDelegate: NSObjectProtocol {
    // 头部视图
    func topViewForPageView(_ pageView: TGPageView) -> UIView?
    // 头部视图高度
    func topViewHeightForPageView(_ pageView: TGPageView) -> CGFloat
    
    // 标题数组 -> 设置标题数据，就使用内部布局
    func pageTitlesForPageView(_ pageView: TGPageView) -> [String]
    // 标题数组高度
    func pageTitleViewHeightForPageView(_ pageView: TGPageView) -> CGFloat
    // 标题视图 -> 使用自定义布局
    func pageTitleViewForPageView(_ pageView: TGPageView) -> TGPageTitleView?
    
    // 控制器数组
    func controllersForPageView(_ pageView: TGPageView) -> [TGPageContent]
}

extension TGPageDelegate {
    // 头部视图
    func topViewForPageView(_ pageView: TGPageView) -> UIView? {
        return nil
    }
    // 头部视图高度
    func topViewHeightForPageView(_ pageView: TGPageView) -> CGFloat {
        return 0
    }
    
    // 标题数组 -> 设置标题数据，就使用内部布局
    func pageTitlesForPageView(_ pageView: TGPageView) -> [String] {
        return []
    }
    // 标题数组高度
    func pageTitleViewHeightForPageView(_ pageView: TGPageView) -> CGFloat {
        return 40
    }
    // 标题视图 -> 使用自定义布局
    func pageTitleViewForPageView(_ pageView: TGPageView) -> TGPageTitleView? {
        return nil
    }
}


// MARK: - 子视图应该实现的协议
protocol TGPageContent where Self: UIViewController {
    var canScroll: Bool { set get }
    var scrollView: UIScrollView? { get }
    
    // scrollView 滚动回调 -> 在子视图的 scrollViewDidScroll 方法中主动调用
    var scrollViewDidScroll: ((UIScrollView) -> Void)? { set get }
}
