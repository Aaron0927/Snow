//
//  ComparisonBarView.swift
//  Snow
//
//  Created by kim on 2024/9/26.
//

import UIKit

// 横向数据对比图
class ComparisonBarView: UIView {
    private lazy var hstack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            leftProgressView,
            middleProgressView,
            rightProgressView
        ])
        stack.axis = .horizontal
        return stack
    }()
    
    private lazy var leftProgressView: BarView = BarView(clipPostion: .right)
    private lazy var middleProgressView: BarView = BarView(clipPostion: .all)
    private lazy var rightProgressView: BarView = BarView(clipPostion: .left)
    
    private lazy var downImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "down")
        return imageView
    }()
    private lazy var downLabel: UILabel = {
        let label = UILabel()
        label.text = "981"
        label.textColor = UIColor.hex("22A775")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var upImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "up")
        return imageView
    }()
    private lazy var upLabel: UILabel = {
        let label = UILabel()
        label.text = "3952"
        label.textColor = UIColor.hex("F04848")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    var leftProgress: CGFloat = 0.5 {
        didSet {
            leftProgressView.progress = leftProgress
        }
    }
    var middleProgress: CGFloat = 0 {
        didSet {
            middleProgressView.progress = middleProgress
        }
    }
    var rightProgress: CGFloat = 0.5 {
        didSet {
            rightProgressView.progress = rightProgress
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    private func setupUI() {
        addSubview(downImageView)
        addSubview(downLabel)
        addSubview(upImageView)
        addSubview(upLabel)
        addSubview(hstack)
        
        downImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
            make.size.equalTo(upImageView)
        }
        downLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(downImageView.snp.right).offset(5)
        }
        upImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-12)
            make.size.equalTo(CGSize(width: 12, height: 12))
        }
        upLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(upImageView.snp.left).offset(-5)
        }
        
        hstack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(downLabel.snp.right).offset(10)
            make.right.equalTo(upLabel.snp.left).offset(-10)
            make.height.equalTo(8)
        }
        leftProgressView.backgroundColor = UIColor.hex("22A775")
        middleProgressView.backgroundColor = UIColor.hex("787C86")
        rightProgressView.backgroundColor = UIColor.hex("F04848")
        leftProgressView.layer.cornerRadius = 2
        middleProgressView.layer.cornerRadius = 2
        rightProgressView.layer.cornerRadius = 2
    }
    
    // 单个裁剪视图
    class BarView: UIView {
        // 裁剪位置
        struct ClipPosition: OptionSet {
            let rawValue: Int
            
            static let left = ClipPosition(rawValue: 1 << 0)
            static var right = ClipPosition(rawValue: 1 << 1)
            static let all: ClipPosition = [.left, .right]
        }
        
        private var shapeLayer: CAShapeLayer?
        private var clipPosition: ClipPosition
        var progress: CGFloat = 0 {
            didSet {
                // 更新视图宽度
                self.snp.remakeConstraints { make in
                    make.width.equalToSuperview().multipliedBy(progress)
                }
            }
        }
        
        init(clipPostion: ClipPosition) {
            self.clipPosition = clipPostion
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            if shapeLayer?.superlayer == nil {
                setupLayers()
            }
        }
        
        override var backgroundColor: UIColor? {
            didSet {
                shapeLayer?.fillColor = backgroundColor?.cgColor
            }
        }
        
        private func setupLayers() {
            let cornerRadius: CGFloat = self.frame.height / 2
            shapeLayer = CAShapeLayer()
            let path = UIBezierPath()
            path.lineJoinStyle = .round
            path.lineCapStyle = .round
            if clipPosition.contains(.left) {
                // 裁剪左边
                path.move(to: CGPoint(x: cornerRadius, y: 0))
                path.addLine(to: CGPoint(x: 0, y: self.frame.height))
            } else {
                path.move(to: CGPoint(x: 0, y: 0))
                path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi * (-0.5), endAngle: CGFloat.pi * 0.5, clockwise: false)
            }
            path.addLine(to: CGPoint(x: self.frame.width - cornerRadius, y: self.frame.height))
            if clipPosition.contains(.right) {
                // 裁剪右边
                path.addLine(to: CGPoint(x: self.frame.width, y: 0))
            } else {
                path.addArc(withCenter: CGPoint(x: self.frame.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi * (-0.5), clockwise: false)
            }
            path.close()
            shapeLayer?.path = path.cgPath
            layer.mask = shapeLayer
        }
    }
}
