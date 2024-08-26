//
//  TestBViewController.swift
//  Snow
//
//  Created by kim on 2024/8/26.
//

import UIKit

private let kCellID: String = "kCellID"

class TestBViewController: TGPageContentController {
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
    }
}

// MARK: - 设置 UI
extension TestBViewController {
    private func setupUI() {
        scrollView = tableView
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
}

// MARK: - UITableView DataSource
extension TestBViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellID)!
        cell.backgroundColor = .randomColor
        return cell
    }
}

extension TestBViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollDidScroll = scrollDidScroll {
            scrollDidScroll(scrollView)
        }
    }
}
