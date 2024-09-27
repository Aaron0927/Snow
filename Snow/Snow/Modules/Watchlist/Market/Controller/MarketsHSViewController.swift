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
    var scrollView: UIScrollView? { innerScrollView }
    
    // scrollView 滚动回调 -> 在子视图的 scrollViewDidScroll 方法中主动调用
    var scrollViewDidScroll: ((UIScrollView) -> Void)? = nil
    
    // MARK: - 懒加载属性
    private lazy var innerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            blockGroupView,
            iconGroupView,
//            overviewView,
            changesView,
        ])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var blockGroupView: MarketsBlockGroupView = {
        let view = MarketsBlockGroupView()
        return view
    }()
    
    private lazy var iconGroupView: MarketsIconGroupView = {
        let view = MarketsIconGroupView()
        return view
    }()
    
    private lazy var overviewView: MarketsOverviewView = {
        let view = MarketsOverviewView()
        return view
    }()
    
    private lazy var changesView: MarketChangesView = {
        let view = MarketChangesView()
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
//        view.addSubview(blockGroupView)
//        view.addSubview(iconGroupView)
//        view.addSubview(overviewView)
//        view.addSubview(changesView)
        
        view.addSubview(innerScrollView)
        innerScrollView.addSubview(contentView)
        
        innerScrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
//        contentView.addArrangedSubview(blockGroupView)
//        contentView.addArrangedSubview(iconGroupView)
//        contentView.addArrangedSubview(overviewView)
//        contentView.addArrangedSubview(changesView)
    }
}
