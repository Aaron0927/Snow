//
//  HotProgressView.swift
//  Snow
//
//  Created by kim on 2024/9/25.
//

import UIKit

// 热度进度图
class HotProgressView: UIView {
    var progress: CGFloat {
        didSet {
            updateMaskLayer()
        }
    }
    private var gradientLayer: CAGradientLayer?
    private var maskLayer: CAShapeLayer?
    
    init(progress: CGFloat) {
        self.progress = progress
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if gradientLayer?.superlayer == nil {
            setupLayers()
        }
        updateMaskLayer()
    }
    
    private func setupLayers() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = self.bounds
        gradientLayer?.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer?.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer?.colors = [UIColor.hex("F54345").cgColor, UIColor.hex("FE9028").cgColor]
        gradientLayer?.locations = [0, 1]
        
        maskLayer = CAShapeLayer()
        updateMaskLayer()
        gradientLayer?.mask = maskLayer
        layer.addSublayer(gradientLayer!)
    }
    
    func updateMaskLayer() {
        guard let maskLayer = maskLayer else { return }

        let maskH: CGFloat = bounds.height * progress
        let maskY: CGFloat = bounds.height - maskH
        let maskRect = CGRect(x: 0, y: maskY, width: self.bounds.width, height: maskH)
        maskLayer.frame = self.bounds
        maskLayer.path = UIBezierPath(roundedRect: maskRect, cornerRadius: self.layer.cornerRadius).cgPath

        // 强制布局更新,确保 mask 立即生效
        layoutIfNeeded()
    }
}
