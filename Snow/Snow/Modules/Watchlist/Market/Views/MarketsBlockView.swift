//
//  MarketsBlockView.swift
//  Snow
//
//  Created by kim on 2024/9/10.
//

import UIKit
import TGCoreKit

class MarketsBlockView: UIView {
    // MARK: - 懒加载视图
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "北证50"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "606.01"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private lazy var zdfLabel: UILabel = {
        let label = UILabel()
        label.text = "-5.25 -0.88%"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private var gradientLayer: CALayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("valid init")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if gradientLayer == nil {
            gradientLayer = createGradientLayer()
            gradientLayer?.frame = self.bounds
            self.layer.insertSublayer(gradientLayer!, at: 0)
        }
    }
}

// MARK: - 设置 UI
extension MarketsBlockView {
    private func setupUI() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel, priceLabel, zdfLabel
        ])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(12)
            make.right.lessThanOrEqualTo(-12)
        }
    }
    
    // 背景渐变色
    private func createGradientLayer() -> CALayer {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        layer.colors = [
            UIColor(hex: "#90EE9080").cgColor,
            UIColor(hex: "#FFFFFF80").cgColor
        ]
        layer.locations = [0, 1]
        return layer
    }
}
