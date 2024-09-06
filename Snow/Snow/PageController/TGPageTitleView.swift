//
//  TGPageTitleView.swift
//  Snow
//
//  Created by kim on 2024/8/30.
//

import UIKit
import TGCoreKit

protocol TGPageTitleDelegate {
    func pageTitle(pageTitleView: TGPageTitleView, didSelectAt index: Int)
}


private let kLineW: CGFloat = 10
private let kLineH: CGFloat = 3

class TGPageTitleView: UIView {
    // MARK: - 懒加载属性
    private var indicatorView: UIView?
    
    // MARK: - 自定义属性
    private var titles: [String]
    private var titleLabels: [UILabel] = []
    private var currentSelectIndex: Int = 0
    var delegate: TGPageTitleDelegate?
    
    // MARK: - 配置属性
    // 是否显示指示器
    public var showIndicator: Bool = true
    // 正常颜色
    public var itemNormalColor: UIColor = UIColor(r: 102, g: 102, b: 102)
    // 选中颜色
    public var itemSelectColor: UIColor = UIColor(r: 51, g: 51, b: 51)

    
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
            label.textColor = itemNormalColor
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
        
        if showIndicator {
            indicatorView = UIView()
            indicatorView!.backgroundColor = UIColor(hex: "#333333")
            indicatorView!.translatesAutoresizingMaskIntoConstraints = false
            indicatorView!.layer.cornerRadius = kLineH / 2
            indicatorView!.layer.masksToBounds = true
            addSubview(indicatorView!)
            NSLayoutConstraint.activate([
                indicatorView!.widthAnchor.constraint(equalToConstant: kLineW),
                indicatorView!.heightAnchor.constraint(equalToConstant: kLineH),
                indicatorView!.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                indicatorView!.centerXAnchor.constraint(equalTo: titleLabels[0].centerXAnchor)
            ])
        }
        updateLineViewPosition(at: 0)
    }
    
    func updateLineViewPosition(at index: Int) {
        let currentLabel = titleLabels[currentSelectIndex]
        let nextLabel = titleLabels[index]
        
        UIView.animate(withDuration: 0.25) {
            self.indicatorView?.center.x = nextLabel.center.x
            currentLabel.font = .systemFont(ofSize: 16, weight: .regular)
            nextLabel.font = .systemFont(ofSize: 16, weight: .bold)
            currentLabel.textColor = self.itemNormalColor
            nextLabel.textColor = self.itemSelectColor
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
        self.indicatorView?.center.x = currentLabel.center.x + distance * progress
        
        // 更新颜色
        // 颜色变化范围
        let normalColor = itemNormalColor.rgbaValue()
        let selectColor = itemSelectColor.rgbaValue()
        let colorDelta = (selectColor.red - normalColor.red, selectColor.green - normalColor.green, selectColor.blue - normalColor.blue)
        // souceLabel 颜色变化
        currentLabel.textColor = UIColor(r: selectColor.red - colorDelta.0 * progress, g: selectColor.green - colorDelta.1 * progress, b: selectColor.blue - colorDelta.2 * progress)
        // targetLabel 颜色变化
        targetLabel.textColor = UIColor(r: normalColor.red + colorDelta.0 * progress, g: normalColor.green + colorDelta.1 * progress, b: normalColor.blue + colorDelta.2 * progress)
    }
    
    // 滑动结束后更新
    func update(targetIndex index: Int) {
        let currentLabel = titleLabels[currentSelectIndex]
        let nextLabel = titleLabels[index]
        
        currentLabel.textColor = itemNormalColor
        nextLabel.textColor = itemSelectColor
        currentLabel.font = .systemFont(ofSize: 16, weight: .regular)
        nextLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        currentSelectIndex = index
    }
}
