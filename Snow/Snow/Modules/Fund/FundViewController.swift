//
//  FundViewController.swift
//  Snow
//
//  Created by kim on 2024/9/30.
//

import UIKit
import TGCoreKit

class FundViewController: UIViewController {
    private lazy var topView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
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

extension FundViewController: TGPageDelegate {
    func controllersForPageView(_ pageView: TGPageView) -> [TGPageContent] {
        var controllers = [TGPageContent]()
        controllers.append(TestDViewController())
        for _ in 0..<5 {
            let vcd = TestDViewController()
            controllers.append(vcd)
        }
        controllers.append(TestEViewController())
        return controllers
    }
    
    func pageTitlesForPageView(_ pageView: TGPageView) -> [String] {
        return ["A股", "港股", "美股", "全球", "基金", "期货", "更多"]
    }
    
    func topViewForPageView(_ pageView: TGPageView) -> UIView? {
        return topView
    }
    
    func topViewHeightForPageView(_ pageView: TGPageView) -> CGFloat {
        return 300
    }
    
}
