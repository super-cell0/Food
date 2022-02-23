//
//  RestaurantDetailTextCell.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/11/15.
//

import UIKit

class RestaurantDetailTextCell: UITableViewCell {
    
    @IBOutlet var descriptionLabel: UILabel! {
        //使文字可以多行呈现
        didSet {
            descriptionLabel.adjustsFontForContentSizeCategory = true
            descriptionLabel.numberOfLines = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
