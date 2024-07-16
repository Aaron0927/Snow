//
//  SlideMenuView.swift
//  Snow
//
//  Created by kim on 2024/7/16.
//

import UIKit
import SnapKit

class SlideMenuView: UIView {

    private lazy var scrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var hstackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 配置 scrollView
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(hstackView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        hstackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        let titles = ["热门", "自选", "咨询", "达人", "视频", "基金", "私募", "ETF", "热门", "自选", "咨询", "达人", "视频", "基金", "私募", "ETF"]
        for title in titles {
            let item = createItem(title)
            hstackView.addArrangedSubview(item)
        }
    }
    
    // 创建子视图
    private func createItem(_ title: String) -> UIButton {
        let btn = UIButton(type: .custom)
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.darkText, for: .normal)
        btn.addTarget(self, action: #selector(SlideMenuView.test(_:)), for: .touchUpInside)
        return btn
    }
    
    @objc private func test(_ sender: UIButton) {
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        var offsetX = sender.center.x - scrollView.center.x
        if offsetX < 0 {
            offsetX = 0
        }
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
}

extension SlideMenuView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
    }
}
