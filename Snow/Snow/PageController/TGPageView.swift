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

private class TGCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureClass = NSClassFromString("UIScrollViewPanGestureRecognizer"),
           gestureRecognizer.isMember(of: panGestureClass) {
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
}

class TGPageView: UIView {
    // MARK: - 懒加载属性
    private lazy var scrollView: TGNestScrollView = {
        let scrollView = TGNestScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return scrollView
    }()
    
    private lazy var scrollContentView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private lazy var collectionView: TGCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        
        let collectionView = TGCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TGPageCollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        return collectionView
    }()
    
    private lazy var controllers: [TGPageContentController] = {
        guard let controllers = delegate?.controllersForPageView(self) else {
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
    
    private lazy var pageTitleView: TGPageTitleView = {
        let titles = self.delegate?.pageTitlesForPageView(self) ?? []
        let titlePageViewH = self.delegate?.pageTitleViewHeightForPageView(self)
        let titlePageView = TGPageTitleView(titles: titles)
        titlePageView.delegate = self
        return titlePageView
    }()
    
    
    // MARK: - Properties
    private var canScroll: Bool = true {
        didSet {
            if oldValue == canScroll {
                return
            }
            // 父 scrollView 不可以滚动时设置子视图滚动
            if scrollView.contentSize.height <= scrollView.frame.height {
                canScroll = false
                controllers.forEach { $0.canScroll = true }
                return
            }
            
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
    private var selectIndex: Int = 0
    private var currentOffset: CGFloat = 0
    private weak var parentController: UIViewController?
    weak var delegate: TGPageDelegate?

    // MARK: - 系统回调
    init(parentController: UIViewController) {
        self.parentController = parentController
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        subviews.forEach { $0.removeFromSuperview()}
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 父 scrollView 不可以滚动时设置子视图滚动
        if scrollView.contentSize.height <= scrollView.frame.height {
            canScroll = false
        }
    }
}

// MARK: - 设置 UI
extension TGPageView {
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        scrollContentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        if let topView = delegate?.topViewForPageView(self) {
            scrollContentView.addArrangedSubview(topView)
            let topViewH = delegate?.topViewHeightForPageView(self) ?? 0
            topView.snp.makeConstraints { make in
                make.height.equalTo(topViewH)
            }
        }
        
        let titlePageViewH = self.delegate?.pageTitleViewHeightForPageView(self)
        scrollContentView.addArrangedSubview(pageTitleView)
        pageTitleView.snp.makeConstraints { make in
            make.height.equalTo(titlePageViewH!)
        }
        scrollContentView.addArrangedSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(self).offset(-titlePageViewH!)
        }
        
        controllers.forEach {
            self.parentController?.addChild($0)
            $0.didMove(toParent: self.parentController)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TGPageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath) as! TGPageCollectionViewCell
        cell.configure(with: controllers[indexPath.item])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TGPageView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - UIScrollView Delegate
extension TGPageView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 防止 collectionView 滚动的时候，scrollView 上下滚动
        if scrollView == self.collectionView {
            self.scrollView.isScrollEnabled = false
            self.currentOffset = scrollView.contentOffset.x
        } else if scrollView == self.scrollView {
            self.collectionView.isScrollEnabled = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let maxOffset: CGFloat = pageTitleView.frame.minY
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
            
            var currentIndex = 0
            var nextIndex = 0
            var progress: CGFloat = 0
            
            // 判断滚动方向
            if scrollView.contentOffset.x > currentOffset {
                // 向右滑动
                currentIndex = Int(currentOffset / scrollView.bounds.width)
                nextIndex = Int(ceil(scrollView.contentOffset.x / scrollView.bounds.width))
                progress = (scrollView.contentOffset.x - currentOffset) / scrollView.bounds.width
            } else {
                // 向左滑动
                currentIndex = Int(currentOffset / scrollView.bounds.width)
                nextIndex = Int(floor(scrollView.contentOffset.x / scrollView.bounds.width))
                progress = (currentOffset - scrollView.contentOffset.x) / scrollView.bounds.width
            }
            if progress > 1 {
                progress = 1
            }
            print("currentIndex:\(currentIndex), nextIndex:\(nextIndex), progress:\(progress)")
            if nextIndex >= 0 && nextIndex < controllers.count {
                // 更新 titleView
                pageTitleView.updateIndicatorView(from: currentIndex, to: nextIndex, progress: progress)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.collectionView {
            self.scrollView.isScrollEnabled = true
        } else if scrollView == self.scrollView {
            self.collectionView.isScrollEnabled = true
        }
    }
}

// MARK: - TGPageTitleViewDelegate
extension TGPageView: TGPageTitleDelegate {
    func pageTitle(pageTitleView: TGPageTitleView, didSelectAt index: Int) {
        collectionView.setContentOffset(CGPoint(x: collectionView.frame.width * CGFloat(index), y: 0), animated: false)
    }
}
