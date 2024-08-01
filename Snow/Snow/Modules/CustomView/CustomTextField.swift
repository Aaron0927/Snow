//
//  CustomTextField.swift
//  Snow
//
//  Created by kim on 2024/8/1.
//

import UIKit

class CustomTextField: UITextField {

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.leftViewRect(forBounds: bounds)
        iconRect.origin.x += 15
        return iconRect
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.placeholderRect(forBounds: bounds)
        iconRect.origin.x += 5
        return iconRect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.editingRect(forBounds: bounds)
        iconRect.origin.x += 5
        return iconRect
    }
    
    // 调整文本的位置
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.textRect(forBounds: bounds)
        textRect.origin.x += 5
        return textRect
    }
}
