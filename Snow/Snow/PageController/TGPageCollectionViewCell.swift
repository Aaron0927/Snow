//
//  TGPageCollectionViewCell.swift
//  Snow
//
//  Created by kim on 2024/8/30.
//

import UIKit

class TGPageCollectionViewCell: UICollectionViewCell {
    var childController: TGPageContentController?
    
    func configure(with controller: TGPageContentController) {
        // 添加子控制器
        childController = controller
        contentView.addSubview(controller.view)
        controller.view.frame = contentView.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 通知子控制器
        controller.didMove(toParent: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 在重用单元格时清理之前的子控制器
        if let controller = childController {
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
            childController = nil
        }
    }
}
