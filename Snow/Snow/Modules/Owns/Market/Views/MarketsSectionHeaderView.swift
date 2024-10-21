//
//  MarketsSectionHeaderView.swift
//  Snow
//
//  Created by kim on 2024/9/10.
//

import UIKit

class MarketsSectionHeaderView: UIView {
    // MARK: - 懒加载属性
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "市场总览"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private(set) lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow_right")
        return imageView
    }()
    
    private(set) lazy var closeBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.hex("#F7F8FA")
        btn.layer.cornerRadius = 9
        btn.setTitle("收起", for: .normal)
        btn.setTitleColor(UIColor.hex("#666666"), for: .normal)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpOutside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 8)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(arrowImageView)
        addSubview(closeBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(0)
        }
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(0)
        }
        closeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.width.equalTo(32)
            make.height.equalTo(18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeAction() {
        
    }
}
