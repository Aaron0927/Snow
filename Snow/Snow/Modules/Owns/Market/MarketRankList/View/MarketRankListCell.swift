//
//  MarketRankListCell.swift
//  Snow
//
//  Created by kim on 2024/9/30.
//

import UIKit

class MarketRankListCell: UITableViewCell {
    // MARK: - 懒加载属性
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "同辉信息"
        label.textColor = .hex("333333")
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.text = "BJ430090"
        label.textColor = .hex("666666")
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "3.77"
        label.textColor = .hex("F04848")
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var zdfLabel: UILabel = {
        let label = UILabel()
        label.text = "+30.00%"
        label.textColor = .hex("F04848")
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var vstack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameLabel,
            codeLabel
        ])
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .leading
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.separatorInset = .zero
                
        addSubviews([
            vstack, priceLabel, zdfLabel
        ])
        
        vstack.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.right.equalTo(priceLabel.snp.right)
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
