//
//  MarketRankContentController.swift
//  Snow
//
//  Created by kim on 2024/9/27.
//

import UIKit
import TGCoreKit

private let kCellID = "MarketRankContentCellID"

class MarketRankContentController: UIViewController, TGPageContent {
    // MARK: - TGPageContent
    var canScroll: Bool = false {
        didSet {
            print("what!!")
            
        }
    }
    var scrollViewDidScroll: ((UIScrollView) -> Void)? = nil
    var scrollView: UIScrollView? { tableView }
    
    // MARK: - 懒加载数据
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MarketRankListCell.self, forCellReuseIdentifier: kCellID)
        tableView.contentOffset = .zero
        return tableView
    }()
    
    private lazy var headerView: MarketRankListHeaderView = {
        let view = MarketRankListHeaderView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

}

// MARK: - 设置 UI
extension MarketRankContentController {
    private func setupUI() {
        view.addSubviews([
            tableView
        ])
        
        tableView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
//        tableView.tableHeaderView = MarketRankListHeaderView(frame: CGRectMake(0, 0, kScreenW, 40))
    }
}

// MARK: - UITableView DataSource
extension MarketRankContentController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellID) as! MarketRankListCell
        return cell
    }
}

// MARK: - UITableView Delegate
extension MarketRankContentController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollViewDidScroll = scrollViewDidScroll {
            scrollViewDidScroll(scrollView)
        }
    }
}
