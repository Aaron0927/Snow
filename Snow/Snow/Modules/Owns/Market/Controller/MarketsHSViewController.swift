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
    var canScroll: Bool = true
    var scrollView: UIScrollView? { innerScrollView }
    // scrollView 滚动回调 -> 在子视图的 scrollViewDidScroll 方法中主动调用
    var scrollViewDidScroll: ((UIScrollView) -> Void)? = nil
    
    // MARK: - 懒加载属性
    private lazy var innerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var contentView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
//            blockGroupView,
//            iconGroupView,
//            overviewView,
            changesView,
            rankSectionView,
            rankController.view
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
    
    private lazy var rankSectionView: MarketsSectionHeaderView = {
        let view = MarketsSectionHeaderView()
        view.titleLabel.text = "沪深京榜单"
        view.titleLabel.textColor = UIColor(hex: "#333333")
        view.titleLabel.font = .systemFont(ofSize: 20, weight: .medium)
        view.closeBtn.isHidden = true
        return view
    }()
    
    private lazy var rankController: MarketRankViewController = {
        let controller = MarketRankViewController()
        return controller
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
        addChild(rankController)
        view.addSubview(innerScrollView)
        innerScrollView.addSubview(contentView)
        rankController.didMove(toParent: self)
        
        innerScrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        rankSectionView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        rankController.view.snp.makeConstraints { make in
            make.height.equalTo(self.view.snp.height).offset(-40)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension MarketsHSViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollViewDidScroll = scrollViewDidScroll {
            scrollViewDidScroll(scrollView)
        }
    }
}
