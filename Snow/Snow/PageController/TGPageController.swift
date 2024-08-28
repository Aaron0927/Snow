//
//  TGPageController.swift
//  Snow
//
//  Created by kim on 2024/8/26.
//

import UIKit

private let kCellID: String = "kCellID"

private class TGNestScrollView: UIScrollView, UIGestureRecognizerDelegate {
    /// 这是实现手势穿透的关键代码。
    /// 返回 YES 允许两者同时识别。 默认实现返回 NO（默认情况下不能同时识别两个手势）
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class TGPageController: UIViewController {
    // MARK: - 懒加载属性
    private lazy var scrollView: TGNestScrollView = {
        let scrollView = TGNestScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        return collectionView
    }()
    weak var delegate: TGPageControllerDelegate?
    private lazy var controllers: [TGPageContent] = {
        guard let controllers = delegate?.controllersForPageController(self) else {
            return []
        }
        controllers.forEach { vc in
            vc.scrollViewDidScroll = { scrollView in
                if !vc.canScroll {
                    scrollView.contentOffset = .zero
                } else if (scrollView.contentOffset.y <= 0) {
                    vc.canScroll = false
                    // 父视图可以滚动
                    self.canScroll = true
                }
            }
        }
        return controllers
    }()
    
    private var selectIndex: Int = 0
    
    // MARK: - Properties
    private var canScroll: Bool = true {
        didSet {
            if canScroll {
                // 父视图可以滚动的时候，子视图不可以滚动
                controllers.forEach {
                    $0.canScroll = false
                    $0.scrollView?.contentOffset = .zero
                }
            } else {
                // 滑动到顶部，标记子视图可以滚动
                controllers.forEach { $0.canScroll = true }
            }
        }
    }
    
    

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置代理为子类
        self.delegate = self as? TGPageControllerDelegate
        setupUI()
    }
}

// MARK: - 设置 UI
extension TGPageController {
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(collectionView)
        
        scrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        scrollContentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        if let topView = delegate?.topViewForPageController(self) {
            scrollContentView.addSubview(topView)
            topView.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
            }
            collectionView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(topView.snp.bottom)
                make.bottom.equalToSuperview()
                make.height.equalTo(scrollView)
            }
        } else {
            collectionView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(scrollView)
            }
        }
        
        controllers.forEach {
            addChild($0)
            $0.didMove(toParent: self)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TGPageController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath)
        let childView = controllers[indexPath.item].view as UIView
        // 确保子视图已添加到单元格中
        if childView.superview == nil {
            cell.contentView.addSubview(childView) // 使用 contentView 添加
            childView.frame = cell.contentView.bounds
            childView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TGPageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - UIScrollView Delegate
extension TGPageController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 防止 collectionView 滚动的时候，scrollView 上下滚动
        if scrollView == self.collectionView {
            self.scrollView.isScrollEnabled = false
        } else {
            self.collectionView.isScrollEnabled = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let maxOffset: CGFloat = scrollView.contentSize.height - scrollView.bounds.height
            if !canScroll {
                scrollView.contentOffset = CGPoint(x: 0, y: maxOffset)
            } else if scrollView.contentOffset.y >= maxOffset {
                scrollView.contentOffset = CGPoint(x: 0, y: maxOffset)
                if (0..<controllers.count).contains(selectIndex), let _ = controllers[selectIndex].scrollView {
                    canScroll = false
                }
            }
        } else if scrollView == self.collectionView {
            let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            self.selectIndex = index
            if controllers[index].scrollView == nil {
                canScroll = true
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.collectionView {
            self.scrollView.isScrollEnabled = true
        } else {
            self.collectionView.isScrollEnabled = true
        }
    }
}
