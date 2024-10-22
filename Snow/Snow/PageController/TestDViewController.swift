//
//  TestDViewController.swift
//  Snow
//
//  Created by kim on 2024/8/26.
//

import UIKit
import TGCoreKit

private let kCellID: String = "kCellID"

class TestDViewController: UIViewController, TGPageContent {
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
    
    var canScroll: Bool = false
    var scrollView: UIScrollView? { self.tableView }
    var scrollViewDidScroll: ((UIScrollView) -> Void)?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        print("\(self) \(#function)")
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        print("\(self) \(#function)")
//    }
}

// MARK: - 设置 UI
extension TestDViewController {
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
}

// MARK: - UITableView DataSource
extension TestDViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellID)!
        cell.backgroundColor = .randomColor
        return cell
    }
}

extension TestDViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollViewDidScroll = scrollViewDidScroll {
            scrollViewDidScroll(scrollView)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
