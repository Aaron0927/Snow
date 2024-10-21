//
//  MarketsController.swift
//  Snow
//
//  Created by kim on 2024/9/3.
//

import UIKit

// 行情页面
class MarketsController: UIViewController {
    // MARK: - 懒加载属性
    private lazy var titleView: PageTitleView = {
        let titleView = PageTitleView(titles: ["A股", "港股", "美股", "全球", "基金", "期货", "更多"])
        titleView.style = .fixed(60)
        titleView.delegate = self
        return titleView
    }()

    private lazy var contentView: PageContentView = {
        let contentView = PageContentView(parentController: self)
        contentView.delegate = self
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.green
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.blue
        contentView.controllers = [MarketsAViewController(), vc2, vc3, UIViewController(), UIViewController(), UIViewController(), UIViewController()]
        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

// MARK: - 设置 UI
extension MarketsController {
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


extension MarketsController: PageTitleDelegate, PageContentDelegate {
    func pageTitle(pageTitleView: PageTitleView, didSelectAt index: Int) {
        contentView.updateCollectionViewOffset(to: index)
    }
    
    func didScrollBetweenPages(from sourcePageIndex: Int, to targetPageIndex: Int, withProgress progress: CGFloat, in pageContent: PageContentView) {
        titleView.updateView(from: sourcePageIndex, to: targetPageIndex, progress: progress)
    }
}
