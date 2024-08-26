//
//  TestAViewController.swift
//  Snow
//
//  Created by kim on 2024/8/26.
//

import UIKit

private let kCellID: String = "kCellID"

class TestAViewController: TGPageContentController {
    // MARK: - 懒加载属性
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellID)
        return tableView
    }()
    
    // MARK: - LifeCycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
//        NotificationCenter.default.addObserver(self, selector: #selector(tableViewCanScroll(_:)), name: NSNotification.Name("TableViewCanScroll"), object: nil)
    }
    
//    @objc private func tableViewCanScroll(_ notifi: Notification) {
//        tableCanScroll = true
//    }

}

// MARK: - 设置 UI
extension TestAViewController {
    private func setupUI() {
        scrollView = tableView
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
}

// MARK: - UITableView DataSource
extension TestAViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellID)!
        cell.backgroundColor = .randomColor
        return cell
    }
}

extension TestAViewController: UITableViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if canScroll == false {
//            scrollView.contentOffset = CGPoint.zero
//        } else if (scrollView.contentOffset.y <= 0) {
//            canScroll = false
//            // 通知ScrollView改变CanScroll的状态
//            NotificationCenter.default.post(name: NSNotification.Name("ScrollViewCanScroll"), object: nil, userInfo: nil)
//        }
//    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollDidScroll = scrollDidScroll {
            scrollDidScroll(scrollView)
        }
    }
}
