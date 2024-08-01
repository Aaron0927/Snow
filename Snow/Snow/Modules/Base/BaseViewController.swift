//
//  BaseViewController.swift
//  Snow
//
//  Created by kim on 2024/7/16.
//

import UIKit

class BaseViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "返回", image: UIImage(), primaryAction: nil, menu: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        
        // 设置导航栏透明
        // 设置导航栏背景为透明色图片
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // 设置导航栏阴影为透明色图片
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // 添加自定义导航栏背景
    func addNavBar(_ color: UIColor) {
        let size = CGSize(width: view.bounds.width, height: getNavBarAndStatusBarHeight())
        let navImageView = UIImageView(image: UIImage(size: size, color: color))
        view.addSubview(navImageView)
    }
}
