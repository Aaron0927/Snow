//
//  UIView+Extension.swift
//  Snow
//
//  Created by kim on 2024/9/27.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
