//
//  TestEViewController.swift
//  Snow
//
//  Created by kim on 2024/8/28.
//

import UIKit

class TestEViewController: UIViewController, TGPageContentController {
    var canScroll: Bool = false
    var scrollViewDidScroll: ((UIScrollView) -> Void)?
    var scrollView: UIScrollView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
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
