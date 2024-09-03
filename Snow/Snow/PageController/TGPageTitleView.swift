//
//  TGPageTitleView.swift
//  Snow
//
//  Created by kim on 2024/8/30.
//

import UIKit

protocol TGPageTitleDelegate {
    func pageTitle(pageTitleView: TGPageTitleView, didSelectAt index: Int)
}


private let kLineW: CGFloat = 20
private let kLineH: CGFloat = 3

class TGPageTitleView: UIView {
    // MARK: - 懒加载属性
    private lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = kLineH / 2
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - 自定义属性
    private var titles: [String]
    private var titleLabels: [UILabel] = []
    private var currentSelectIndex: Int = 0 {
        didSet {
            delegate?.pageTitle(pageTitleView: self, didSelectAt: currentSelectIndex)
        }
    }
    var delegate: TGPageTitleDelegate?
    
    // MARK: - 系统方法回调
    init(titles: [String]) {
        self.titles = titles
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 设置 UI
extension TGPageTitleView {
    private func setupView() {
        let kLabelW: CGFloat = kScreenW / CGFloat(titles.count)
        let kLabelH: CGFloat = 20
        var originX: CGFloat = 0
        
        for (index, title) in self.titles.enumerated() {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.tag = index
            label.text = title
            label.textColor = UIColor(hex: "#333333")
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 15)
            addSubview(label)
            titleLabels.append(label)
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: originX),
                label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                label.widthAnchor.constraint(equalToConstant: kLabelW),
                label.heightAnchor.constraint(equalToConstant: kLabelH)
            ])
            originX += kLabelW

            
            // 添加点击事件
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TGPageTitleView.tapItemAction(_:)))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tapGesture)
        }
        
        addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.widthAnchor.constraint(equalToConstant: kLineW),
            lineView.heightAnchor.constraint(equalToConstant: kLineH),
            lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
        updateLineViewPosition(at: 0)
    }
    
    private func updateLineViewPosition(at index: Int) {
        let currentLabel = titleLabels[currentSelectIndex]
        let nextLabel = titleLabels[index]
        UIView.animate(withDuration: 0.25) {
            self.lineView.center.x = nextLabel.center.x
            currentLabel.font = .systemFont(ofSize: 15, weight: .regular)
            nextLabel.font = .systemFont(ofSize: 15, weight: .medium)
        } completion: { _ in
            self.currentSelectIndex = index
        }
    }
}

// MARK: - Action
extension TGPageTitleView {
    @objc private func tapItemAction(_ gesture: UIGestureRecognizer) {
        guard let index = gesture.view?.tag else { return }
        if index == currentSelectIndex {
            return
        }
        updateLineViewPosition(at: index)
    }
}
