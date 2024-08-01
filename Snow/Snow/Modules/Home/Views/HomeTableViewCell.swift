//
//  HomeTableViewCell.swift
//  Snow
//
//  Created by kim on 2024/7/25.
//

import UIKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var publishTime: UILabel!
    @IBOutlet weak var focusButton: UIButton!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var commentUserNameLabel: UILabel!
    @IBOutlet weak var commentContentLabel: UILabel!
    
    var viewModel: HomeCellViewModel? {
        didSet {
            viewModel?.name.observe { [unowned self] in
                self.userNameLabel.text = $0
            }
            viewModel?.image.observe { [unowned self] in
                let url = URL(string: $0)
                self.userImageView.kf.setImage(with: url)
            }
            viewModel?.publishTime.observe { [unowned self] in
                self.publishTime.text = $0
            }
            viewModel?.content.observe { [unowned self] in
                self.contentLabel.attributedText = $0
            }
            viewModel?.focus.observe { [unowned self] in
                self.focusButton.isSelected = $0
            }
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.focusButton.layer.borderColor = UIColor.red.cgColor
    }
}
