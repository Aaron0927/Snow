//
//  MarketsSectionHeaderView.swift
//  Snow
//
//  Created by kim on 2024/9/10.
//

import UIKit

class MarketsSectionHeaderView: UIView {
    // MARK: - 懒加载属性
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "市场总览"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(arrowImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
        }
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-12)
        }
    }
    
}
