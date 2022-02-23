//
//  RestaurantDetailTwoTableViewCell.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/11/15.
//

import UIKit

class RestaurantDetailTwoTableViewCell: UITableViewCell {
    //使文字可以多行呈现
    @IBOutlet var column1TitleLabel: UILabel! {
        didSet {
            column1TitleLabel.adjustsFontForContentSizeCategory = true
            column1TitleLabel.text = column1TitleLabel.text?.uppercased()
            column1TitleLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var column1TextLabel: UILabel! {
        didSet {
            column1TextLabel.adjustsFontForContentSizeCategory = true
            column1TextLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var column2TitleLabel: UILabel! {
        didSet {
            column2TitleLabel.adjustsFontForContentSizeCategory = true
            column2TitleLabel.text = column2TitleLabel.text?.uppercased()
            column2TitleLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var column2TextLabel: UILabel! {
        didSet {
            column2TextLabel.adjustsFontForContentSizeCategory = true
            column2TextLabel.numberOfLines = 0
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
