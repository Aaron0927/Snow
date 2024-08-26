//
//  IndividualContainerController.swift
//  Snow
//
//  Created by kim on 2024/8/26.
//

import UIKit

class IndividualContainerController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func testAction(_ sender: Any) {
        navigationController?.pushViewController(TGPageController(), animated: true)
    }
}
