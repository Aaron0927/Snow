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


private let kLineW: CGFloat = 10
private let kLineH: CGFloat = 3
private let kSelectColor: (CGFloat, CGFloat, CGFloat) = (51, 51, 51)
private let kNormalColor: (CGFloat, CGFloat, CGFloat) = (102, 102, 102)

class TGPageTitleView: UIView {
    // MARK: - 懒加载属性
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#333333")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = kLineH / 2
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - 自定义属性
    private var titles: [String]
    private var titleLabels: [UILabel] = []
    private var currentSelectIndex: Int = 0
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
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 16)
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
        
        addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.widthAnchor.constraint(equalToConstant: kLineW),
            indicatorView.heightAnchor.constraint(equalToConstant: kLineH),
            indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: titleLabels[0].centerXAnchor)
        ])
        updateLineViewPosition(at: 0)
    }
    
    func updateLineViewPosition(at index: Int) {
        let currentLabel = titleLabels[currentSelectIndex]
        let nextLabel = titleLabels[index]
        
        UIView.animate(withDuration: 0.25) {
            self.indicatorView.center.x = nextLabel.center.x
            currentLabel.font = .systemFont(ofSize: 16, weight: .regular)
            nextLabel.font = .systemFont(ofSize: 16, weight: .bold)
            currentLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            nextLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        }
        
        currentSelectIndex = index
        delegate?.pageTitle(pageTitleView: self, didSelectAt: currentSelectIndex)
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

// MARK: - Public
extension TGPageTitleView {
    // 滑动过程中更新
    func updateIndicatorView(from sourceIndex: Int, to targetIndex: Int, progress: CGFloat) {
        if sourceIndex == targetIndex {
            return
        }
        let currentLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 更新位置
        let distance = targetLabel.center.x - currentLabel.center.x
        self.indicatorView.center.x = currentLabel.center.x + distance * progress
        
        // 更新颜色
        // 颜色变化范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        // souceLabel 颜色变化
        currentLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        // targetLabel 颜色变化
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
    }
    
    // 滑动结束后更新
    func update(targetIndex index: Int) {
        let currentLabel = titleLabels[currentSelectIndex]
        let nextLabel = titleLabels[index]
        
        currentLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        nextLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        currentLabel.font = .systemFont(ofSize: 16, weight: .regular)
        nextLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        currentSelectIndex = index
    }
}
