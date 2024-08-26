//
//  NestScrollView.swift
//  Snow
//
//  Created by kim on 2024/8/26.
//

import UIKit

class NestScrollView: UIScrollView {

    

}

extension NestScrollView: UIGestureRecognizerDelegate {
    /// 这是实现手势穿透的关键代码。
    /// 返回 YES 允许两者同时识别。 默认实现返回 NO（默认情况下不能同时识别两个手势）
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
