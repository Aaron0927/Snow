//
//  HomeViewController.swift
//  Snow
//
//  Created by kim on 2024/7/16.
//

import UIKit
import SnapKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = HomeViewModel()
    private var datas = [HomeCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
    }
}

// MARK: - 设置页面 UI
extension HomeViewController {
    private func setupUI() {
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let bar = UINib(nibName: "HomeNavigationBar", bundle: nil).instantiate(withOwner: nil).first as! HomeNavigationBar
        addCustomNavBar(bar)
    }
}

// MARK: - 请求数据
extension HomeViewController {
    private func loadData() {
        viewModel.requestData()
        viewModel.datas.observe { [unowned self] datas in
            self.datas = datas
            self.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
//        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFlowCell") as! HomeTableViewCell
        cell.viewModel = datas[indexPath.row]
        return cell
    }
}
