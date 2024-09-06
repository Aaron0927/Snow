//
//  IndividualContainerController.swift
//  Snow
//
//  Created by kim on 2024/8/26.
//

import UIKit

class IndividualContainerController: BaseViewController {
    // MARK: - 懒加载属性
    private lazy var pageController: IndividualTestController = {
        let controller = IndividualTestController()
        return controller
    }()
    
    // 行情视图
    private lazy var marketController: MarketsController = {
        let controller = MarketsController()
        return controller
    }()
    
    private lazy var pageTitleView: TGPageTitleView = {
        let titleView = TGPageTitleView(titles: ["自选", "行情", "市场"])
        titleView.showIndicator = false
        return titleView
    }()
    
    private lazy var pageView: TGPageView = {
        let pageView = TGPageView(parentController: self)
        pageView.delegate = self
        return pageView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    

    @IBAction func testAction(_ sender: Any) {
        navigationController?.pushViewController(IndividualStockController(), animated: true)
    }
}

// MARK: - 设置 UI
extension IndividualContainerController {
    private func setupUI() {
        addNavBar(.white)
        navigationItem.titleView = pageTitleView
        
        view.addSubview(pageView)
        pageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}

extension IndividualContainerController: TGPageDelegate {    
    func pageTitleViewForPageView(_ pageView: TGPageView) -> TGPageTitleView? {
        return pageTitleView
    }
    
    func controllersForPageView(_ pageView: TGPageView) -> [TGPageContent] {
        var arrs = [TGPageContent]()
        for _ in 0..<3 {
            let vc = MarketsAViewController()
            arrs.append(vc)
        }
        return arrs
    }
}
