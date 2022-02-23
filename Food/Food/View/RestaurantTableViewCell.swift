//
//  RestaurantTableViewCell.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/10/11.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            //在iPad中自动调整字体
            nameLabel.adjustsFontForContentSizeCategory = true
            //显示字段完整
            nameLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var locationLabel: UILabel! {
        didSet {
            locationLabel.adjustsFontForContentSizeCategory = true
            locationLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var typeLabel: UILabel! {
        didSet {
            typeLabel.adjustsFontForContentSizeCategory = true
            typeLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var thumbnailImageView: UIImageView! {
        //图片设置圆角
        didSet {
            thumbnailImageView.layer.cornerRadius = 10.0
            thumbnailImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

