//
//  TGPageController.swift
//  Snow
//
//  Created by kim on 2024/8/26.
//

import UIKit

private let kTopViewH: CGFloat = 300
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
    
    private lazy var topView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
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
    
    // 子控制器
    private lazy var otherControllers: [TGPageContent] = {
        var controllers = [TGPageContent]()
        for _ in 0..<4 {
            let vcd = TestDViewController()
            vcd.scrollViewDidScroll = { scrollView in
                if !vcd.canScroll {
                    scrollView.contentOffset = .zero
                } else if (scrollView.contentOffset.y <= 0) {
                    vcd.canScroll = false
                    // 父视图可以滚动
                    self.canScroll = true
                }
            }
            controllers.append(vcd)
        }
        controllers.append(TestEViewController())
        return controllers
    }()
    
    private var selectIndex: Int = 0
    
    // MARK: - Properties
    private var canScroll: Bool = true {
        didSet {
            if canScroll {
                // 父视图可以滚动的时候，子视图不可以滚动
                otherControllers.forEach {
                    $0.canScroll = false
                    $0.scrollView?.contentOffset = .zero
                }
            } else {
                // 滑动到顶部，标记子视图可以滚动
                otherControllers.forEach { $0.canScroll = true }
            }
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - 设置 UI
extension TGPageController {
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(topView)
        scrollContentView.addSubview(collectionView)
        
        scrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        scrollContentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        topView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kTopViewH)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalToSuperview()
            make.height.equalTo(scrollView)
        }
        
        otherControllers.forEach { addChild($0) }
    }
}

// MARK: - UICollectionViewDataSource
extension TGPageController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath)
        cell.addSubview(otherControllers[indexPath.item].view)
        otherControllers[indexPath.item].view.frame = cell.bounds
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
                if let _ = otherControllers[selectIndex].scrollView {
                    canScroll = false
                }
            }
        } else if scrollView == self.collectionView {
            let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            self.selectIndex = index
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
