//
//  MarketsIconGroupView.swift
//  Snow
//
//  Created by kim on 2024/9/10.
//

import UIKit
import RxSwift
import RxCocoa

private let kCellID: String = "kCellID"

// TODO: 修改为无限加载
class MarketsIconGroupView: UIView {
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
        collectionView.register(MarketsIconGroupCell.self, forCellWithReuseIdentifier: kCellID)
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
        pageControl.numberOfPages = 2
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
extension MarketsIconGroupView {
    private func setupUI() {
        addSubview(collectionView)
        addSubview(pageControl)
        
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top)
            make.height.equalTo(75)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MarketsIconGroupView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath) as! MarketsIconGroupCell
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MarketsIconGroupView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height)
    }
}


// MARK: - Cell
class MarketsIconGroupCell: UICollectionViewCell {
    private lazy var vstack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.imageView, self.titleLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 5
        return stack
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_share_live_news")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "测试"
        label.textColor = .darkText
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(vstack)
        vstack.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
