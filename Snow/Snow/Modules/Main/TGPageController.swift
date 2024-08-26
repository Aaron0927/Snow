//
//  TGPageController.swift
//  Snow
//
//  Created by kim on 2024/8/26.
//

import UIKit

private let kTopViewH: CGFloat = 300
private let kCellID: String = "kCellID"

// 子视图应该实现的协议
protocol TGPageContent where Self: UIViewController {
    var canScroll: Bool { set get }
    var scrollView: UIScrollView? { get }
}


class TGPageController: UIViewController {
    // MARK: - 懒加载属性
    private lazy var scrollView: NestScrollView = {
        let scrollView = NestScrollView()
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
    private lazy var childControllers: [TGPageContentController] = {
        var controllers = [TGPageContentController]()
        controllers.append(TestAViewController())
        controllers.append(TestBViewController())
        for _ in 0..<2 {
            controllers.append(TestCViewController())
        }
        return controllers
    }()
    
    private lazy var otherControllers: [TGPageContent] = {
        var controllers = [TGPageContent]()
        for _ in 0..<4 {
            let vcd = TestDViewController()
            vcd.scrollView?.delegate = self
//            vcd.scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
            controllers.append(vcd)
        }
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
    deinit {
        otherControllers.forEach{
            $0.scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        childControllers.forEach { vc in
            vc.scrollDidScroll = { scrollView in
                guard let scrollView = scrollView else {
                    self.canScroll = true
                    return
                }
                if !vc.canScroll {
                    scrollView.contentOffset = .zero
                } else if (scrollView.contentOffset.y <= 0) {
                    vc.canScroll = false
                    self.canScroll = true
                    
                    
                }
            }
        }
    }
    
    // 处理 KVO 变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 需要获取当前控制器
//        if keyPath == "contentOffset" {
//            if let newValue = change?[.newKey] as? CGPoint {
//                let vc = self.otherControllers[self.selectIndex]
//                if !vc.canScroll {
////                    vc.scrollView?.contentOffset = .zero
//                } else if (newValue.y <= 0) {
//                    vc.canScroll = false
//                    self.canScroll = true
//                }
//            }
//        }
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
        otherControllers[indexPath.item].view.backgroundColor = UIColor.randomColor
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
                canScroll = false
            }
        } else if scrollView == self.collectionView {
            let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            self.selectIndex = index
        } else {
            let vc = self.otherControllers[selectIndex]
            if !vc.canScroll {
                vc.scrollView?.contentOffset = .zero
            } else if (scrollView.contentOffset.y <= 0) {
                vc.canScroll = false
                self.canScroll = true
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
