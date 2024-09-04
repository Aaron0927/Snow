//
//  IndividualTestController.swift
//  Snow
//
//  Created by kim on 2024/8/28.
//

import UIKit

class IndividualTestController: UIViewController {
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
        
        // 坐标从 0 开始
        self.navigationItem.title = "TT"
        addNavBar(.white)

    }

}

extension IndividualTestController: TGPageDelegate {    
    func controllersForPageView(_ pageController: TGPageView) -> [TGPageContentController] {
        return controllers
    }
    
    func topViewForPageView(_ pageController: TGPageView) -> UIView? {
        return topView
    }
    
    func topViewHeightForPageView(_ pageController: TGPageView) -> CGFloat {
        return 300
    }
    
    func pageTitlesForPageView(_ pageController: TGPageView) -> [String] {
        return ["page1", "page2", "page3"]
    }
}

