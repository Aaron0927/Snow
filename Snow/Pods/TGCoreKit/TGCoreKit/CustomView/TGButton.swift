//
//  TGButton.swift
//  TGCoreKit
//
//  Created by kim on 2024/8/16.
//

import UIKit

public class TGButton: UIButton {
    public var tapEdgeInset: UIEdgeInsets = .zero // 扩展点击范围
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.bounds.outset(by: tapEdgeInset).contains(point)
    }
}
