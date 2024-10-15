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
    var canScroll: Bool = true
    var scrollViewDidScroll: ((UIScrollView) -> Void)? = nil
    var scrollView: UIScrollView? { tableView }
    
    // MARK: - 懒加载数据
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellID)
        return tableView
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
    }
    
    // 设置头部视图
}

// MARK: - UITableView DataSource
extension MarketRankContentController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellID)!
        cell.backgroundColor = .randomColor
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
