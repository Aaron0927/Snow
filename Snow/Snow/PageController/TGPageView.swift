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

class TGPageView: UIViewController {
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
        collectionView.register(TGPageCollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        return collectionView
    }()
    
    private lazy var controllers: [TGPageContentController] = {
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
    
    private lazy var pageTitleView: TGPageTitleView = {
        let titles = self.delegate?.pageTitlesForPageController(self) ?? []
        let titlePageViewH = self.delegate?.pageTitleViewHeightForPageController(self)
        let titlePageView = TGPageTitleView(titles: titles)
        titlePageView.delegate = self
        return titlePageView
    }()
    
    private weak var delegate: TGPageControllerDelegate?
    private var selectIndex: Int = 0
    
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
    
    

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置代理为子类
        self.delegate = self as? TGPageControllerDelegate
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 父 scrollView 不可以滚动时设置子视图滚动
        if scrollView.contentSize.height <= scrollView.frame.height {
            canScroll = false
        }
    }
}

// MARK: - 设置 UI
extension TGPageView {
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        scrollContentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        if let topView = delegate?.topViewForPageController(self) {
            scrollContentView.addArrangedSubview(topView)
            let topViewH = delegate?.topViewHeightForPageController(self) ?? 0
            topView.snp.makeConstraints { make in
                make.height.equalTo(topViewH)
            }
        }
        
        let titlePageViewH = self.delegate?.pageTitleViewHeightForPageController(self)
        scrollContentView.addArrangedSubview(pageTitleView)
        pageTitleView.snp.makeConstraints { make in
            make.height.equalTo(titlePageViewH!)
        }
        scrollContentView.addArrangedSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(self.view).offset(-titlePageViewH!)
        }
        
        controllers.forEach {
            addChild($0)
            $0.didMove(toParent: self)
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
        } else {
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

// MARK: - TGPageTitleViewDelegate
extension TGPageView: TGPageTitleDelegate {
    func pageTitle(pageTitleView: TGPageTitleView, didSelectAt index: Int) {
        collectionView.setContentOffset(CGPoint(x: collectionView.frame.width * CGFloat(index), y: 0), animated: false)
    }
}
