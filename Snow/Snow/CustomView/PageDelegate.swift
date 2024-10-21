//
//  PageDelegate.swift
//  Snow
//
//  Created by kim on 2024/10/21.
//

import UIKit

public protocol PageDelegate: NSObjectProtocol {
    // 头部视图
    func topViewForPageView(_ pageView: PageView) -> UIView?
    // 头部视图高度
    func topViewHeightForPageView(_ pageView: PageView) -> CGFloat?
    
    // 标题数组 -> 设置标题数据，就使用内部布局
    func pageTitlesForPageView(_ pageView: PageView) -> [String]
    // 标题数组高度
    func pageTitleViewHeightForPageView(_ pageView: PageView) -> CGFloat
    
    // 控制器数组
    func controllersForPageView(_ pageView: PageView) -> [PageContent]
}

extension PageDelegate {
    func topViewForPageView(_ pageView: PageView) -> UIView? {
        return nil
    }
    
    func topViewHeightForPageView(_ pageView: PageView) -> CGFloat? {
        return nil
    }
    
    func pageTitleViewHeightForPageView(_ pageView: PageView) -> CGFloat {
        return 40
    }
}

public protocol PageContent where Self: UIViewController {
    var canScroll: Bool { set get }
    var scrollView: UIScrollView? { get }
}
