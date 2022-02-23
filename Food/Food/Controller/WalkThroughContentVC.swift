//
//  WalkThroughContentVC.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/12/23.
//

import UIKit

class WalkThroughContentVC: UIViewController {
    
    @IBOutlet var contentImageView: UIImageView!
    
    @IBOutlet var headingLabel: UILabel! {
        didSet {
            headingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var subHeadingLabel: UILabel! {
        didSet {
            subHeadingLabel.numberOfLines = 0
        }
    }
    
    //页面索引值
    var index = 0
    
    var heading = ""
    var subHeading = ""
    var imageFile = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headingLabel.text = heading
        subHeadingLabel.text = subHeading
        contentImageView.image = UIImage(named: imageFile)
    }
    

}
