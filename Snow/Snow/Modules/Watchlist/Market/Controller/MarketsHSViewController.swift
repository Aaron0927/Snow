//
//  MarketsHSViewController.swift
//  Snow
//
//  Created by kim on 2024/9/10.
//

import UIKit
import TGCoreKit

class MarketsHSViewController: UIViewController, TGPageContent {
    // MARK: - TGPageContent
    var canScroll: Bool = false
    var scrollView: UIScrollView? { nil }
    
    // scrollView 滚动回调 -> 在子视图的 scrollViewDidScroll 方法中主动调用
    var scrollViewDidScroll: ((UIScrollView) -> Void)? = nil
    
    // MARK: - 懒加载属性
    private lazy var blockGroupView: MarketsBlockGroupView = {
        let view = MarketsBlockGroupView()
        return view
    }()
    
    private lazy var iconGroupView: MarketsIconGroupView = {
        let view = MarketsIconGroupView()
        return view
    }()
    
    
    // MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
}

// MARK: - 设置 UI
extension MarketsHSViewController {
    private func setupUI() {
        view.addSubview(blockGroupView)
        view.addSubview(iconGroupView)
        
        blockGroupView.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(12)
        }
        iconGroupView.snp.makeConstraints { make in
            make.left.right.equalTo(blockGroupView)
            make.top.equalTo(blockGroupView.snp.bottom).offset(12)
        }
    }
}
