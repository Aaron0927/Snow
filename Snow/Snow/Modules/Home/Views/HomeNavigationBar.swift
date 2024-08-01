//
//  HomeNavigationBar.swift
//  Snow
//
//  Created by kim on 2024/8/1.
//

import UIKit

class HomeNavigationBar: UIView {
    @IBOutlet weak var textField: CustomTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTextField()
    }
    
    private func setupTextField() {
        let leftView = UIImageView()
        leftView.image = UIImage(named: "icon_navbar_search_night")
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 20
    }
}
