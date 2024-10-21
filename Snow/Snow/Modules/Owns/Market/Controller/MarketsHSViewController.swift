//
//  MarketsHSViewController.swift
//  Snow
//
//  Created by kim on 2024/9/10.
//

import UIKit

// 沪深页面
class MarketsHSViewController: UIViewController {
    // MARK: - 懒加载属性
    private lazy var pageView: PageView = {
        let pageView = PageView(parentController: self)
        pageView.delegate = self
        pageView.titleView.style = .fixed(80)
        return pageView
    }()
    
    private lazy var contentView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            blockGroupView,
            iconGroupView,
            overviewView,
            changesView,
            rankSectionView,
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
    
    
    // MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
}

// MARK: - 设置 UI
extension MarketsHSViewController {
    private func setupUI() {
        rankSectionView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        view.addSubview(pageView)
        pageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
    }
}

extension MarketsHSViewController: PageDelegate {
    func pageTitlesForPageView(_ pageView: PageView) -> [String] {
        return ["涨幅榜", "跌幅榜", "换手率", "成交额", "年初至今"]
    }
    
    func controllersForPageView(_ pageView: PageView) -> [PageContent] {
        return [MarketRankContentController(), MarketRankContentController(), MarketRankContentController(), MarketRankContentController(), MarketRankContentController()]
    }
    
    // 头部视图
    func topViewForPageView(_ pageView: PageView) -> UIView? {
        return contentView
    }
}
