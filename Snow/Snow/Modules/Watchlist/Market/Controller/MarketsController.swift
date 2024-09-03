//
//  MarketsController.swift
//  Snow
//
//  Created by kim on 2024/9/3.
//

import UIKit

class MarketsController: TGPageController {
    
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

        
    }
   

}

extension MarketsController: TGPageControllerDelegate {
    func controllersForPageController(_ pageController: TGPageController) -> [TGPageContentController] {
        return controllers
    }
    
    func pageTitlesForPageController(_ pageController: TGPageController) -> [String] {
        return ["page1", "page2", "page3"]
    }
}
