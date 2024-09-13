//
//  MarketsAViewController.swift
//  Snow
//
//  Created by kim on 2024/9/3.
//

import UIKit
import TGCoreKit

class MarketsAViewController: UIViewController, TGPageContent {
    
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
    func controllersForPageView(_ pageController: TGPageView) -> [TGPageContent] {
        var controllers = [TGPageContent]()
        controllers.append(MarketsHSViewController())
        for _ in 0..<4 {
            let vcd = TestDViewController()
            controllers.append(vcd)
        }
        return controllers
    }
    
    func pageTitlesForPageView(_ pageController: TGPageView) -> [String] {
        return ["沪深", "北证", "板块", "科创", "沪深港通"]
    }
}
