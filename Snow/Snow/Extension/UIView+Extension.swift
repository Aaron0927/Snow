//
//  UIView+Extension.swift
//  Snow
//
//  Created by kim on 2024/9/27.
//

import UIKit

private var widthConstraintIdentifier = "widthConstraintIdentifier"
private var heightConstraintIdentifier = "heightConstraintIdentifier"

extension UIView {
    /// 扩展添加视图的方法
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
    
    /// 生成弹簧视图
    static func spring(_ axis: NSLayoutConstraint.Axis) -> UIView {
        let spring = UIView()
        switch axis {
        case .horizontal:
            spring.makeWidthConstraint(1000, priority: .defaultLow)
        case .vertical:
            spring.makeHeightConstraint(1000, priority: .defaultLow)
        @unknown default:
            break
        }
        return spring
    }
}

// MARK: - 扩展约束快捷方式
extension UIView {
    func makeWidthConstraint(_ constant: CGFloat, priority: UILayoutPriority = .required) {
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant)
        constraint.priority = priority
        constraint.identifier = widthConstraintIdentifier
        NSLayoutConstraint.activate([constraint])
    }
    
    func makeHeightConstraint(_ constant: CGFloat, priority: UILayoutPriority = .required) {
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant)
        constraint.priority = priority
        constraint.identifier = widthConstraintIdentifier
        NSLayoutConstraint.activate([constraint])
    }
}
