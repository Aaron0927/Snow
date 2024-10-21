//
//  IndividualContainerController.swift
//  Snow
//
//  Created by kim on 2024/8/26.
//

import UIKit

class IndividualContainerController: BaseViewController {
    // MARK: - 懒加载属性
    private lazy var titleView: PageTitleView = {
        let titleView = PageTitleView(titles: ["自选", "行情", "组合"])
        titleView.delegate = self
        titleView.style = .fixed(60)
        titleView.itemNormalFont = .systemFont(ofSize: 20)
        titleView.itemSelectFont = .systemFont(ofSize: 20, weight: .medium)
        titleView.showIndicator = false
        return titleView
    }()
    
    private lazy var contentView: PageContentView = {
        let contentView = PageContentView(parentController: self)
        contentView.controllers = [MarketsController(), UIViewController(), UIViewController()]
        contentView.delegate = self
        return contentView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

// MARK: - 设置 UI
extension IndividualContainerController {
    private func setupUI() {
        addNavBar(.white)
        navigationItem.titleView = titleView
        titleView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(44)
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}

extension IndividualContainerController: PageTitleDelegate, PageContentDelegate {
    func pageTitle(pageTitleView: PageTitleView, didSelectAt index: Int) {
        contentView.updateCollectionViewOffset(to: index)
    }
    
    func didScrollBetweenPages(from sourcePageIndex: Int, to targetPageIndex: Int, withProgress progress: CGFloat, in pageContent: PageContentView) {
        titleView.updateView(from: sourcePageIndex, to: targetPageIndex, progress: progress)
    }
}
