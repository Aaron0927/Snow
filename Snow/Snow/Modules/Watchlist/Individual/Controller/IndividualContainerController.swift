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
        
        addChild(marketController)
        view.addSubview(marketController.view)
        marketController.didMove(toParent: self)
        marketController.view.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}
