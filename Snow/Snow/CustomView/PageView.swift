//
//  PageView.swift
//  Snow
//
//  Created by kim on 2024/10/16.
//

import UIKit

private extension UIView {
    func getViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        repeat {
            nextResponder = nextResponder?.next
        } while !(nextResponder is UIViewController) && nextResponder != nil
        return nextResponder as? UIViewController
    }
}

private protocol GestureRecognizableView: UIView {}

private class NestScrollView: UIScrollView, UIGestureRecognizerDelegate, GestureRecognizableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 这是实现手势穿透的关键代码。
    /// 返回 YES 允许两者同时识别。 默认实现返回 NO（默认情况下不能同时识别两个手势）
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view is UITableView || otherGestureRecognizer.view is GestureRecognizableView {
            return true
        }
        return false
    }
}

public class PageView: UIView {
    // MARK: - 懒加载属性
    private lazy var scrollView: NestScrollView = {
        let scrollView = NestScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        if #available(iOS 13.0, *) {
            scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        }
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return scrollView
    }()
    
    private lazy var scrollContentView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    private(set) lazy var titleView: PageTitleView = {
        let titleView = PageTitleView(titles: self.delegate?.pageTitlesForPageView(self) ?? [])
        titleView.style = .fixed(60)
        titleView.delegate = self
        return titleView
    }()
    
    private(set) lazy var contentView: PageContentView = {
        let contentView = PageContentView(parentController: self.parentController)
        contentView.controllers = self.controllers
        contentView.delegate = self
        return contentView
    }()
    
    // MARK: - Properties
    private lazy var controllers: [PageContent] = {
        guard let controllers = delegate?.controllersForPageView(self) else {
            return []
        }
        controllers.forEach { vc in
            if vc.scrollView == nil {
                vc.canScroll = true
            }
            // KVO 监听
            vc.scrollView?.addObserver(self, forKeyPath: "contentOffset", context: nil)
        }
        return controllers
    }()
    
    private var canScroll: Bool = true {
        didSet {
            if oldValue == canScroll {
                return
            }
            // 父 scrollView 不可以滚动时设置子视图滚动
            if scrollView.contentSize.height < scrollView.frame.height {
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
    
    private weak var parentController: UIViewController?
    public weak var delegate: PageDelegate?
    
    // MARK: - 系统回调
    public init(parentController: UIViewController) {
        self.parentController = parentController
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder")
    }
    
    deinit {
        controllers.forEach {
            $0.scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        subviews.forEach { $0.removeFromSuperview()}
        setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // 父 scrollView 不可以滚动时设置子视图滚动
        if !scrollView.contentSize.equalTo(.zero) &&
            scrollView.contentSize.height <= scrollView.frame.height {
            canScroll = false
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            guard let scrollView = object as? UIScrollView else { return }
            guard let vc = scrollView.getViewController() as? PageContent else { return }
            // 将修改操作延迟到下一个 RunLoop 周期
            DispatchQueue.main.async {
                if !vc.canScroll {
                    scrollView.contentOffset = .zero
                } else if (scrollView.contentOffset.y <= 0) {
                    vc.canScroll = false
                    // 父视图可以滚动
                    self.canScroll = true
                }
            }
        }
    }
}

// MARK: - 设置 UI
extension PageView {
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        // add topView
        if let topView = delegate?.topViewForPageView(self) {
            scrollContentView.addArrangedSubview(topView)
        }
        
        // add titleView
        scrollContentView.addArrangedSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // add contentView
        scrollContentView.addArrangedSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -40)
        ])
        
        controllers.forEach {
            self.parentController?.addChild($0)
            $0.didMove(toParent: self.parentController)
        }
    }
}

// MARK: - UIScrollView Delegate
extension PageView : UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxOffset: CGFloat = titleView.frame.minY
        if !canScroll {
            scrollView.contentOffset = CGPoint(x: 0, y: maxOffset)
        } else if scrollView.contentOffset.y >= maxOffset {
            scrollView.contentOffset = CGPoint(x: 0, y: maxOffset)
            if (0..<controllers.count).contains(contentView.selectIndex), let _ = controllers[contentView.selectIndex].scrollView {
                canScroll = false
            }
        }
    }
}

// MARK: - PageTitleViewDelegate
extension PageView: PageTitleDelegate {
    func pageTitle(pageTitleView: PageTitleView, didSelectAt index: Int) {
        contentView.updateCollectionViewOffset(to: index)
    }
}

// MARK: - PageContentDelegate
extension PageView: PageContentDelegate {
    func didScrollBetweenPages(from sourcePageIndex: Int, to targetPageIndex: Int, withProgress progress: CGFloat, in pageContent: PageContentView) {
        titleView.updateView(from: sourcePageIndex, to: targetPageIndex, progress: progress)
    }
}
