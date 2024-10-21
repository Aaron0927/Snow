//
//  MarketsAViewController.swift
//  Snow
//
//  Created by kim on 2024/9/3.
//

import UIKit

// A 股页面
class MarketsAViewController: UIViewController {
    // MARK: - 懒加载属性
    private lazy var titleView: PageTitleView = {
        let titleView = PageTitleView(titles: ["沪深", "北证", "板块", "科创", "沪深港通"])
        titleView.delegate = self
        return titleView
    }()

    private lazy var contentView: PageContentView = {
        let contentView = PageContentView(parentController: self)
        contentView.delegate = self
        contentView.controllers = [MarketsHSViewController(), UIViewController(), UIViewController(), UIViewController(), UIViewController()]
        return contentView
    }()

    // MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - 设置 UI
extension MarketsAViewController {
    private func setupUI() {
        // 标题视图
        view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(44)
        }
        // 内容视图
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom)
        }
    }
}

extension MarketsAViewController: PageTitleDelegate, PageContentDelegate {
    func pageTitle(pageTitleView: PageTitleView, didSelectAt index: Int) {
        contentView.updateCollectionViewOffset(to: index)
    }
    
    func didScrollBetweenPages(from sourcePageIndex: Int, to targetPageIndex: Int, withProgress progress: CGFloat, in pageContent: PageContentView) {
        titleView.updateView(from: sourcePageIndex, to: targetPageIndex, progress: progress)
    }
}
