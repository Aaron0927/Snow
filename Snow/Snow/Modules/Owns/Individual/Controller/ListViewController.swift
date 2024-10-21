//
//  ListViewController.swift
//  JXPagingViewExample
//
//  Created by jiaxin on 2019/12/30.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView

class ListViewController: UIViewController {
    lazy var tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    var dataSource: [String] = [String]()
    var isNeedHeader = false
    var isNeedFooter = false
    var isHeaderRefreshed = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        if isNeedHeader {
        }
        if isNeedFooter {
            if #available(iOS 11.0, *) {
                tableView.contentInsetAdjustmentBehavior = .never
            }
        } else {
            //列表的contentInsetAdjustmentBehavior失效，需要自己设置底部inset
//            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: UIApplication.shared.keyWindow!.jx_layoutInsets().bottom, right: 0)
        }
        beginFirstRefresh()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }

    func beginFirstRefresh() {
        if !isHeaderRefreshed {
            if (self.isNeedHeader) {
//                self.tableView.mj_header?.beginRefreshing()
            }else {
                self.isHeaderRefreshed = true
                self.tableView.reloadData()
            }
        }
    }

    @objc func headerRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
//            self.tableView.mj_header?.endRefreshing()
            self.isHeaderRefreshed = true
            self.tableView.reloadData()
        }
    }

    @objc func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
            self.dataSource.append("加载更多成功")
            self.tableView.reloadData()
//            self.tableView.mj_footer?.endRefreshing()
        }
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHeaderRefreshed {
            return dataSource.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = DetailViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListViewController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return self.view
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        
    }
    
    
    func listScrollView() -> UIScrollView { tableView }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        listViewDidScrollCallback?(scrollView)
//    }
}
