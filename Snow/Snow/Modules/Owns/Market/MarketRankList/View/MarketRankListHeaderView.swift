//
//  MarketRankListHeaderView.swift
//  Snow
//
//  Created by kim on 2024/9/27.
//

import UIKit

class MarketRankListHeaderView: UIView {
    // MARK: - 懒加载属性
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "名称"
        label.textColor = .hex("666666")
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "最新价"
        label.textColor = .hex("666666")
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var zdfLabel: UILabel = {
        let label = UILabel()
        label.text = "涨跌幅"
        label.textColor = .hex("666666")
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([
            nameLabel, priceLabel, zdfLabel
        ])
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(priceLabel.snp.right)
        }
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        zdfLabel.snp.makeConstraints { make in
            make.left.equalTo(priceLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.equalTo(-12)
            make.width.equalTo(80)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
