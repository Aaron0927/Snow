//
//  TGPageProtocol.swift
//  Snow
//
//  Created by kim on 2024/8/26.
//

import UIKit

// 定义容器视图协议
protocol TGPageProtocol {
    // TODO: 头部视图
    
    // TODO: 控制器数组
    
    // 获取当前控制器
    
    
}


// 子视图应该实现的协议
protocol TGPageContent where Self: UIViewController {
    var canScroll: Bool { set get }
    var scrollView: UIScrollView? { get }
    
    // scrollView 滚动回调
    var scrollViewDidScroll: ((UIScrollView) -> Void)? { get }
}
