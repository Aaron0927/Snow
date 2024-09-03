//
//  IndividualTestController.swift
//  Snow
//
//  Created by kim on 2024/8/28.
//

import UIKit

class IndividualTestController: TGPageController {
    private lazy var topView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private lazy var controllers: [TGPageContentController] = {
        var controllers = [TGPageContentController]()
        for _ in 0..<2 {
            let vcd = TestDViewController()
            controllers.append(vcd)
        }
        controllers.append(TestEViewController())
        return controllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Test"
    }

}

extension IndividualTestController: TGPageControllerDelegate {    
    func controllersForPageController(_ pageController: TGPageController) -> [TGPageContentController] {
        return controllers
    }
    
    func topViewForPageController(_ pageController: TGPageController) -> UIView? {
        return topView
    }
    
    func topViewHeightForPageController(_ pageController: TGPageController) -> CGFloat {
        return 300
    }
    
    func pageTitlesForPageController(_ pageController: TGPageController) -> [String] {
        return ["page1", "page2", "page3"]
    }
}

