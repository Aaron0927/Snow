//
//  PageContentView.swift
//  Snow
//
//  Created by kim on 2024/10/16.
//

import UIKit
import TGCoreKit

private final class SnowCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureClass = NSClassFromString("UIScrollViewPanGestureRecognizer"),
           gestureRecognizer.isMember(of: panGestureClass) {
            // 手势传递的关键代码
            let panGesture = gestureRecognizer as! UIPanGestureRecognizer
            let velocityX = panGesture.velocity(in: panGesture.view).x
            if velocityX > 0 {
                // 当前在第一个页面，且往左滑动，就放弃该手势，让外层接收
                if contentOffset.x == 0 {
                    return false
                }
            } else if velocityX < 0 {
                // 当前在最后一个页面，且往右滑动，就放弃该手势，让外层接收
                if contentOffset.x + bounds.size.width == contentSize.width {
                    return false
                }
            }
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

protocol PageContentDelegate {
    func didScrollBetweenPages(from sourcePageIndex: Int, to targetPageIndex: Int, withProgress progress: CGFloat, in pageContent: PageContentView)
}

private let kCellID = "kCellID"

public class PageContentView: UIView {
    // MARK: - 懒加载属性
    private lazy var collectionView: SnowCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
                
        let collectionView = SnowCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        return collectionView
    }()
    
    // MARK: - 自定义属性
    private(set) var selectIndex: Int = 0
    private var startOffsetX: CGFloat = 0
    private var isForbidScrollDelegate: Bool = false // 是否禁止滚动
    private weak var parentController: UIViewController?
    var delegate: PageContentDelegate?
    var isDraging: Bool = false // 是否在滚动中
    
    
    public var controllers: [UIViewController] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - 初始化
    public init(parentController: UIViewController?) {
        self.parentController = parentController
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - 设置 UI
extension PageContentView {
    private func setupUI() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        controllers.forEach {
            self.parentController?.addChild($0)
            $0.didMove(toParent: self.parentController)
        }
    }
    
    // 更新偏移量
    func updateCollectionViewOffset(to index: Int) {
        isForbidScrollDelegate = true
        collectionView.setContentOffset(CGPoint(x: collectionView.frame.width * CGFloat(index), y: 0), animated: false)
    }
}

// MARK: - UICollectionViewDataSource
extension PageContentView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath) as! PageCollectionViewCell
        cell.configure(with: controllers[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PageContentView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - UICollectionViewDelegate
extension PageContentView: UICollectionViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDraging = true
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 获取滚动进度，更新指示器位置
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        self.selectIndex = index
        
        // 获取滚动进度，更新指示器位置
        if isForbidScrollDelegate { return }
        let currentOffsetX = scrollView.contentOffset.x
        var sourceIndex = 0
        var targetIndex = 0
        var progress: CGFloat = 0
        
        sourceIndex = Int(startOffsetX / scrollView.bounds.width)
        progress = abs(currentOffsetX - startOffsetX) / scrollView.bounds.width

        // 判断滚动方向
        if currentOffsetX > startOffsetX {
            // 向右滑动
            targetIndex = min(controllers.count - 1, sourceIndex + 1)
        } else {
            // 向左滑动
            targetIndex = max(0, sourceIndex - 1)
        }
        delegate?.didScrollBetweenPages(from: sourceIndex, to: targetIndex, withProgress: progress, in: self)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDraging = false
    }
}

// MARK: - PageCollectionViewCell
private final class PageCollectionViewCell: UICollectionViewCell {
    var childController: UIViewController?
    
    func configure(with controller: UIViewController) {
        // 添加子控制器
        childController = controller
        contentView.addSubview(controller.view)
        controller.view.frame = contentView.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 通知子控制器
        controller.didMove(toParent: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 在重用单元格时清理之前的子控制器
        if let controller = childController {
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
            childController = nil
        }
    }
}
