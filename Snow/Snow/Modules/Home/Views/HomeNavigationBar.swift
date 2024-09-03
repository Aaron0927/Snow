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
        
        translatesAutoresizingMaskIntoConstraints = false
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupTextField()
    }
    
    static func navigationBar() -> HomeNavigationBar {
        UINib(nibName: "HomeNavigationBar", bundle: nil).instantiate(withOwner: self, options: nil).first as! HomeNavigationBar
    }
    
    private func setupTextField() {
        let leftView = UIImageView()
        leftView.image = UIImage(named: "icon_navbar_search_night")
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 15
    }
}
