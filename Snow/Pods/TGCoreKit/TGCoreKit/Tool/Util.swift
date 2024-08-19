//
//  Util.swift
//  TGCoreKit
//
//  Created by kim on 2024/8/16.
//

import UIKit

public extension CGRect {
    // 向外扩大区域
    func outset(by inset: UIEdgeInsets) -> CGRect {
        var rect = self
        rect.origin.x -= inset.left
        rect.origin.y -= inset.top
        rect.size.width += (inset.left + inset.right)
        rect.size.height += (inset.top + inset.bottom)
        return rect
    }
}
