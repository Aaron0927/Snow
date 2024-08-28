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

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func testAction(_ sender: Any) {
        navigationController?.pushViewController(IndividualTestController(), animated: true)
    }
}
