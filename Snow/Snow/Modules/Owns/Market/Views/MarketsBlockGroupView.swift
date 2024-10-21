//
//  MarketsBlockGroupView.swift
//  Snow
//
//  Created by kim on 2024/9/10.
//

import UIKit
import RxSwift
import RxCocoa

private let kBlockGroupCell: String = "kBlockGroupCell"

// TODO: 修改为无限加载
class MarketsBlockGroupView: UIView {
    // MARK: - 懒加载属性
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MarketsBlockGroupCell.self, forCellWithReuseIdentifier: kBlockGroupCell)
        collectionView.rx.didEndDecelerating
            .subscribe(onNext: {
                let currentIndex = Int(self.collectionView.contentOffset.x / self.collectionView.bounds.width)
                self.pageControl.currentPage = currentIndex
            })
            .disposed(by: disposeBag)
        
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = UIColor(hex: "#4169E1")
        pageControl.pageIndicatorTintColor = UIColor(hex: "#DCDCDC")
        pageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                let offsetX = CGFloat(self.pageControl.currentPage) * self.collectionView.bounds.width
                self.collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
            })
            .disposed(by: disposeBag)
        return pageControl
    }()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置 UI
extension MarketsBlockGroupView {
    private func setupUI() {
        addSubview(collectionView)
        addSubview(pageControl)
        
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top)
            make.height.equalTo(82)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MarketsBlockGroupView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBlockGroupCell, for: indexPath) as! MarketsBlockGroupCell
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MarketsBlockGroupView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}


// MARK: - Cell
class MarketsBlockGroupCell: UICollectionViewCell {
    private lazy var hstack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(hstack)
        hstack.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        hstack.addArrangedSubview(MarketsBlockView())
        hstack.addArrangedSubview(MarketsBlockView())
        hstack.addArrangedSubview(MarketsBlockView())
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
