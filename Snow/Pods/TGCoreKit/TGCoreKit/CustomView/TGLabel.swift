//
//  TGLabel.swift
//  TGCoreKit
//
//  Created by kim on 2024/8/16.
//

import UIKit

public class TGLabel: UILabel {
    // 内边距
    public var contentInset: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }

    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: bounds.outset(by: contentInset), limitedToNumberOfLines: numberOfLines)
        
        rect.origin.x -= contentInset.left
        rect.origin.y -= contentInset.top
        rect.size.width += (contentInset.left + contentInset.right)
        rect.size.height += (contentInset.top + contentInset.bottom)
        return rect
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.outset(by: contentInset))
    }
}

// MARK: - 扩展 Label 样式
public protocol LabelStyle {
    associatedtype LabelType: UILabel
    
    func apply(to label: LabelType)
}

extension UILabel {
    // 使用泛型适配所有 UILabel 的子类
    public func apply<S: LabelStyle>(style: S) where S.LabelType: UILabel {
        // 使用 as? 进行类型转换以确保类型匹配
        guard let typedLabel = self as? S.LabelType else {
            return
        }
        style.apply(to: typedLabel)
    }
    
    
    @discardableResult
    public func primaryBold() -> Self {
        self.apply(style: PrimaryBoldLabelStyle())
        return self
    }
}

public struct PrimaryBoldLabelStyle: LabelStyle {
    public typealias LabelType = UILabel
    
    public func apply(to label: UILabel) {
        label.font = systemBoldFont(15)
        label.textColor = UIColor(hex: "#333333")
        label.textAlignment = .center
        label.backgroundColor = .clear
    }
}
