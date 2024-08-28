//
//  TestEViewController.swift
//  Snow
//
//  Created by kim on 2024/8/28.
//

import UIKit

class TestEViewController: UIViewController, TGPageContent {
    var canScroll: Bool = false
    var scrollViewDidScroll: ((UIScrollView) -> Void)?
    var scrollView: UIScrollView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("teste appear")
    }
}
