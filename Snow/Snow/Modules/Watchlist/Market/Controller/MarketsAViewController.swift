//
//  MarketsAViewController.swift
//  Snow
//
//  Created by kim on 2024/9/3.
//

import UIKit

class MarketsAViewController: UIViewController, TGPageContentController {
    
    var canScroll: Bool = true
    var scrollViewDidScroll: ((UIScrollView) -> Void)? = nil
    var scrollView: UIScrollView? = nil
    
    private lazy var pageView: TGPageView = {
        let pageView = TGPageView(parentController: self)
        pageView.delegate = self
        return pageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pageView)
        pageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension MarketsAViewController: TGPageDelegate {
    func controllersForPageView(_ pageController: TGPageView) -> [TGPageContentController] {
        var controllers = [TGPageContentController]()
        for _ in 0..<5 {
            let vcd = TestDViewController()
            controllers.append(vcd)
        }
        return controllers
    }
    
    func pageTitlesForPageView(_ pageController: TGPageView) -> [String] {
        return ["沪深", "北证", "板块", "科创", "沪深港通"]
    }
}
