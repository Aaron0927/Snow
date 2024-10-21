//
//  PageTitleView.swift
//  Snow
//
//  Created by kim on 2024/10/15.
//

import UIKit

protocol PageTitleDelegate {
    func pageTitle(pageTitleView: PageTitleView, didSelectAt index: Int)
}

private let kCellID = "CellID"
private let kLineW: CGFloat = 10
private let kLineH: CGFloat = 3

public class PageTitleView: UIView {
    public enum PageTitleStyle {
        case fixed(CGFloat) // 元素固定宽度
        case fillEqually // 元素平分视图
    }
    
    // MARK: - 懒加载属性
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = true
        collectionView.register(PageTitleCell.self, forCellWithReuseIdentifier: kCellID)
        return collectionView
    }()
    
    private(set) var indicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.backgroundColor = UIColor(hex: "#333333")
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.layer.cornerRadius = kLineH / 2
        indicatorView.layer.masksToBounds = true
        return indicatorView
    }()
    
    // MARK: - 自定义属性
    private var labels: [String] = []
    private var currentSelectIndex: Int = 0
    var delegate: PageTitleDelegate?
    
    // MARK: - 配置属性
    // 是否显示指示器
    public var showIndicator: Bool = true {
        didSet {
            indicatorView.isHidden = !showIndicator
        }
    }
    // 正常颜色
    public var itemNormalColor: UIColor = UIColor(r: 102, g: 102, b: 102) {
        didSet {
            collectionView.reloadData()
        }
    }
    // 选中颜色
    public var itemSelectColor: UIColor = UIColor(r: 51, g: 51, b: 51) {
        didSet {
            collectionView.reloadData()
        }
    }
    // 正常字体
    public var itemNormalFont: UIFont = .systemFont(ofSize: 16) {
        didSet {
            collectionView.reloadData()
        }
    }
    // 选中字体
    public var itemSelectFont: UIFont = .systemFont(ofSize: 16, weight: .bold) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // 页面元素样式
    public var style: PageTitleStyle = .fillEqually {
        didSet {
            collectionView.reloadData()
        }
    }

    init(titles: [String], style: PageTitleStyle = .fillEqually) {
        self.labels = titles
        self.style = style
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - 设置 UI
extension PageTitleView {
    private func setupUI() {
        addSubview(collectionView)
        addSubview(indicatorView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            indicatorView.widthAnchor.constraint(equalToConstant: kLineW),
            indicatorView.heightAnchor.constraint(equalToConstant: kLineH),
            indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    // 设置正常状态样式
    private func setupItemNormalStyle(at cell: UICollectionViewCell?) {
        guard let cell = cell as? PageTitleCell else { return }
        cell.titleLabel.textColor = itemNormalColor
        cell.titleLabel.font = itemNormalFont
    }
    
    // 设置选中状态样式
    private func setupItemSelectedStyle(at cell: UICollectionViewCell?) {
        guard let cell = cell as? PageTitleCell else { return }
        cell.titleLabel.textColor = itemSelectColor
        cell.titleLabel.font = itemSelectFont
        
        updateIndicatorPosition(at: cell)
    }
    
    // 更新指示器位置
    private func updateIndicatorPosition(at cell: UICollectionViewCell?) {
        guard let cell = cell else { return }
        if indicatorView.frame.minX <= 0 {
            indicatorView.center.x = cell.center.x
        } else {
            UIView.animate(withDuration: 0.25) {
                self.indicatorView.center.x = cell.center.x
            }
        }
    }
    
    // 动态更新过度状态
    func updateView(from sourceIndex: Int, to targetIndex: Int, progress: CGFloat) {
        if sourceIndex == targetIndex {
            return
        }
        guard let currentCell = collectionView.cellForItem(at: IndexPath(item: sourceIndex, section: 0)) as? PageTitleCell else { return }
        guard let targetCell = collectionView.cellForItem(at: IndexPath(item: targetIndex, section: 0)) as? PageTitleCell else { return }
        
        let currentLabel = currentCell.titleLabel
        let targetLabel = targetCell.titleLabel
        
        // 更新位置
        let distance = targetCell.center.x - currentCell.center.x
        indicatorView.center.x = currentCell.center.x + distance * progress
        
        // 更新颜色
        // 颜色变化范围
        let normalColor = itemNormalColor.rgbaValue()
        let selectColor = itemSelectColor.rgbaValue()
        let colorDelta = (selectColor.red - normalColor.red, selectColor.green - normalColor.green, selectColor.blue - normalColor.blue)
        // souceLabel 颜色变化
        currentLabel.textColor = UIColor(r: selectColor.red - colorDelta.0 * progress, g: selectColor.green - colorDelta.1 * progress, b: selectColor.blue - colorDelta.2 * progress)
        // targetLabel 颜色变化
        targetLabel.textColor = UIColor(r: normalColor.red + colorDelta.0 * progress, g: normalColor.green + colorDelta.1 * progress, b: normalColor.blue + colorDelta.2 * progress)

        if progress >= 1 {
            // 更新字体
            currentLabel.font = itemNormalFont
            targetLabel.font = itemSelectFont
            currentSelectIndex = targetIndex
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PageTitleView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath) as! PageTitleCell
        cell.titleLabel.text = labels[indexPath.item]
        if indexPath.item == currentSelectIndex {
            setupItemSelectedStyle(at: cell)
        } else {
            setupItemNormalStyle(at: cell)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PageTitleView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch style {
        case .fixed(let width):
            return CGSize(width: width, height: collectionView.frame.height)
        case .fillEqually:
            return CGSize(width: collectionView.frame.width / CGFloat(labels.count), height: collectionView.frame.height)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension PageTitleView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lastCell = collectionView.cellForItem(at: IndexPath(item: currentSelectIndex, section: 0))
        setupItemNormalStyle(at: lastCell)
        let currentCell = collectionView.cellForItem(at: indexPath)
        setupItemSelectedStyle(at: currentCell)
        currentSelectIndex = indexPath.item
        
        // 更新 item 位置
        // 1.获取当前可滚动距离
        var scrollOffsetX = (currentCell?.center.x ?? 0) - collectionView.center.x
        scrollOffsetX = max(min(scrollOffsetX, collectionView.contentSize.width - collectionView.frame.width), 0)
        // 2.更新 scrollView 的偏移量
        collectionView.setContentOffset(CGPoint(x: scrollOffsetX, y: 0), animated: true)
        
        delegate?.pageTitle(pageTitleView: self, didSelectAt: indexPath.item)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(cell.frame)
    }
}

// MARK: - PageTitleCell
private final class PageTitleCell: UICollectionViewCell {
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
