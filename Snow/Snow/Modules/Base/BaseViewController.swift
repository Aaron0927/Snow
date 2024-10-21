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
        
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", image: UIImage(), primaryAction: nil, menu: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        
        // 设置导航栏透明
        // 设置导航栏背景为透明色图片
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // 设置导航栏阴影为透明色图片
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}

extension UIViewController {
    // 添加自定义导航栏背景
    func addNavBar(_ color: UIColor) {
        let size = CGSize(width: view.bounds.width, height:  kStatusAndNavBarH)
        let navImageView = UIImageView(image: UIImage(size: size, color: color))
        view.addSubview(navImageView)
        navImageView.frame = CGRectMake(0, 0, size.width, size.height)
    }
    
    // 添加自定义导航栏视图
    func addCustomNavBar(_ view: UIView) {
        let size = CGSize(width: view.bounds.width, height: kStatusAndNavBarH)
        self.view.addSubview(view)
        view.frame = CGRectMake(0, 0, size.width, size.height)
    }
}
