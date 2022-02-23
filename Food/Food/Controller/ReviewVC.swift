//
//  ReviewVC.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/12/7.
//

import UIKit

class ReviewVC: UIViewController {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    @IBOutlet var closeButton: UIButton!
    
    var restaurant: Restaurant = Restaurant()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = UIImage(data: restaurant.image)
        
        //背景模糊效果
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        //滑入动作
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let scaleTransfrom = CGAffineTransform.init(scaleX: 5, y: 5)
        let moveScaleTransfrom = scaleTransfrom.concatenating(moveRightTransform)
        let moveUpTransfrom = CGAffineTransform.init(translationX: 0, y: -600)
        
        
        //隐藏表情Button
        for rateButton in rateButtons {
            rateButton.transform = moveScaleTransfrom
            rateButton.alpha = 0
        }
        
        closeButton.transform = moveUpTransfrom
        
    }
    
    //建立表情的淡入效果
//    override func viewWillAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 2.5) {
//            self.rateButtons[0].alpha = 1.0
//            self.rateButtons[1].alpha = 1.0
//            self.rateButtons[2].alpha = 1.0
//            self.rateButtons[3].alpha = 1.0
//            self.rateButtons[4].alpha = 1.0
//        }
//    }
    
    //其他渲染动画
    override func viewWillAppear(_ animated: Bool) {
        
        for index in 0...4 {
            UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
                self.rateButtons[index].alpha = 1.0
                self.rateButtons[index].transform = .identity
            }, completion: nil)
        }
        
        //colseButton动画
        UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
            self.closeButton.transform = .identity
        }, completion: nil)
        
        //有粘贴复制就有优化的空间
//        UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
//            self.rateButtons[0].alpha = 1.0
//            self.rateButtons[0].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4, delay: 0.15, options: [], animations: {
//            self.rateButtons[1].alpha = 1.0
//            self.rateButtons[1].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
//            self.rateButtons[2].alpha = 1.0
//            self.rateButtons[2].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4, delay: 0.25, options: [], animations: {
//            self.rateButtons[3].alpha = 1.0
//            self.rateButtons[3].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4, delay: 0.3, options: [], animations: {
//            self.rateButtons[4].alpha = 1.0
//            self.rateButtons[4].transform = .identity
//        }, completion: nil)
    }
    
    
    

}
