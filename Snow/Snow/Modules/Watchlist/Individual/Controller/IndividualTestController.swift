//
//  IndividualTestController.swift
//  Snow
//
//  Created by kim on 2024/8/28.
//

import UIKit

private let kTopViewH: CGFloat = 400

class IndividualTestController: TGPageController {
    private lazy var topView = {
        let view = UIView()
        view.backgroundColor = .red
        view.snp.makeConstraints { make in
            make.height.equalTo(kTopViewH)
        }
        return view
    }()
    
    private lazy var controllers: [TGPageContent] = {
        var controllers = [TGPageContent]()
        for _ in 0..<2 {
            let vcd = TestDViewController()
            controllers.append(vcd)
        }
        controllers.append(TestEViewController())
        return controllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension IndividualTestController: TGPageControllerDelegate {
    func controllersForPageController(_ pageController: TGPageController) -> [TGPageContent] {
        return controllers
    }
    
    func topViewForPageController(_ pageController: TGPageController) -> UIView {
        return topView
    }
}
