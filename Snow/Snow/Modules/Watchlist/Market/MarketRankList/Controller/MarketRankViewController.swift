//
//  MarketRankViewController.swift
//  Snow
//
//  Created by kim on 2024/9/27.
//

import UIKit
import TGCoreKit

class MarketRankViewController: UIViewController {
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

extension MarketRankViewController: TGPageDelegate {
    func controllersForPageView(_ pageController: TGPageView) -> [TGPageContent] {
        var controllers = [TGPageContent]()
        for _ in 0..<5 {
            let vcd = MarketRankContentController()
            controllers.append(vcd)
        }
        return controllers
    }
    
    func pageTitlesForPageView(_ pageController: TGPageView) -> [String] {
        return ["涨幅榜", "跌幅榜", "换手率", "成交额", "年初至今"]
    }
}
