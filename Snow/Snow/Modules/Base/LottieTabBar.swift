//
//  LottieTabBar.swift
//  Snow
//
//  Created by kim on 2024/10/14.
//

import UIKit
import Lottie

class LottieTabBar: UITabBar {
    private var lottieNameArr: [String] = ["tabbar_home", "tabbar_owns_day", "tabbar_fund_day", "tabbar_me_day"]
    private var animationViews: [LottieAnimationView] = []
    private var currentSelectIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAnimationViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // 初始化 animationViews
    private func setupAnimationViews() {
        for name in lottieNameArr {
            let animationView = LottieAnimationView(name: name)
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .playOnce
            animationViews.append(animationView)
        }
    }
    
    // 播放动画
    func play(at index: Int) {
        // 旧数据重置
        let lastTabBarSwappableImageView = tabBarSwappableImageViews[currentSelectIndex]
        lastTabBarSwappableImageView.isHidden = false
        let lastAnimationView = animationViews[currentSelectIndex]
        lastAnimationView.stop()
        lastAnimationView.removeFromSuperview()
        
        // 显示新数据
        let currentTabBarSwappableImageView = tabBarSwappableImageViews[index]
        currentTabBarSwappableImageView.isHidden = true
        let currentAnimationView = animationViews[index]
        currentAnimationView.frame = currentTabBarSwappableImageView.frame
        currentTabBarSwappableImageView.superviewOfTabBarButton()?.addSubview(currentAnimationView)
        currentAnimationView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce, completion: { (finished) in
            // 动画播放完成后跳转至第一帧
            if finished {
                currentAnimationView.currentProgress = index == 0 ? 15.0 / 96.0 : 1 // 跳转至第一帧
            }
        })

        currentSelectIndex = index
    }
}
