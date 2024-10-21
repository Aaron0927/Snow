//
//  BaseTabBarController.swift
//  Snow
//
//  Created by kim on 2024/7/16.
//

import UIKit

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupChilds()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tabBar = tabBar as? LottieTabBar else { return }
        guard let index = tabBar.items?.firstIndex(where: { $0 == item }) else { return }
        
        tabBar.play(at: Int(index))
    }
}

// MARK: - 设置子控制器
extension BaseTabBarController {
    private func setupChilds() {
        // 添加到Tab Bar
        let homeVC = createChildVC(UIViewController(), title: "首页", image: "icon_tabbar_home_day")
        let ownsVC = createChildVC(IndividualContainerController(), title: "自选", image: "icon_tabbar_owns_day")
        let fundVC = createChildVC(UIViewController(), title: "基金", image: "icon_tabbar_fund_day")
        let meVC = createChildVC(UIViewController(), title: "我的", image: "icon_tabbar_me_day")
        
        setValue(LottieTabBar(), forKey: "tabBar")
        viewControllers = [homeVC, ownsVC, fundVC, meVC]
    }
    
    private func createChildVC(_ vc: UIViewController, title: String, image: String) -> UIViewController {
        let nav = BaseNavigationController(rootViewController: vc)
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage(named: image)
        return nav
    }
}
