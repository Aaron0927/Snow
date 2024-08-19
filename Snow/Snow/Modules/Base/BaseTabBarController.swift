//
//  BaseTabBarController.swift
//  Snow
//
//  Created by kim on 2024/7/16.
//

import UIKit
import Lottie

class BaseTabBarController: UITabBarController {
    private var animationView: LottieAnimationView?
    private var currentTabBarSwappableImageView: UIImageView?
    private var lottieNameArr: [String] = ["tabbar_home", "tabbar_owns_day", "tabbar_fund_day", "tabbar_me_day"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        setTabBarItemsRenderingMode()
    }
    
    // 设置图片渲染模式
    private func setTabBarItemsRenderingMode() {
        guard let items = tabBar.items else { return }

        for item in items {
            if let image = item.image {
                item.image = image.withRenderingMode(.alwaysOriginal)
            }
            if let selectedImage = item.selectedImage {
                item.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
            }
        }
    }
}

extension BaseTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        setupAnimation(tabBarController, viewController)
    }
}

// MARK: - AniamtionView
extension BaseTabBarController {
    private func setupAnimation(_ tabBarVC: UITabBarController, _ viewController: UIViewController){
        // 停止上一个 animationView
        if animationView != nil {
            animationView?.stop()
            animationView?.removeFromSuperview()
            animationView = nil
            currentTabBarSwappableImageView?.isHidden = false
        }
        
        // 获取当前点击的是第几个
        guard let index = tabBarVC.viewControllers?.firstIndex(of: viewController) else { return }
        
        // 找到当前的UITabBarButton中的 UITabBarSwappableImageView
        let currentTabBarSwappableImageView = tabBar.tabBarSwappableImageViews[index]
        self.currentTabBarSwappableImageView = currentTabBarSwappableImageView
        
        // 设置 AnimationView 的 frame
        var frame = currentTabBarSwappableImageView.frame
        frame.origin.x = 0
        frame.origin.y = 0
        let animationView: LottieAnimationView? = getAnimationViewAtTabBarIndex(index, currentTabBarSwappableImageView.frame)
        self.animationView = animationView
        self.animationView?.center = currentTabBarSwappableImageView.center
        
        // 将 AnimationView 添加到当前的 UITabBarButton，并隐藏UITabBarSwappableImageView
        currentTabBarSwappableImageView.superview?.addSubview(animationView!)
        currentTabBarSwappableImageView.isHidden = true
        
        // 执行动画
        animationView!.play(fromProgress: 0, toProgress: 1)
    }
    
    private func getAnimationViewAtTabBarIndex(_ index: Int, _ frame: CGRect)-> LottieAnimationView {
        let view = LottieAnimationView(name: lottieNameArr[index])
        view.frame = frame
        view.contentMode = .scaleAspectFill
        view.animationSpeed = 1
        view.loopMode = .playOnce
        return view
    }
}
