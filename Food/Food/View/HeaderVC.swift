//
//  HeaderVC.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/11/14.
//

import UIKit

class HeaderVC: UIView {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            //防止餐厅名字过长显示不全
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!

}
