//
//  WalkThroughVC.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/12/23.
//

import UIKit

class WalkThroughVC: UIViewController {
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    @IBOutlet var skipButton: UIButton! {
        didSet {
            skipButton.layer.cornerRadius = 15.0
            skipButton.layer.masksToBounds = true
        }
        
    }
    
    var walkThroughPageVC: WalkThroughPageVC?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //实现跳过按钮
    @IBAction func skipButtonTapped(sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "已浏览过开始界面")
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: WalkThroughPageVC的取得页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageVC = destination as? WalkThroughPageVC {
            //walkThroughPageVC = pageVC
            //自定协议后更新
            walkThroughPageVC = pageVC
            walkThroughPageVC?.walkThroughDelegate = self
        }
    }
    
    //实现下一页按钮
    @IBAction func nextButtonTapped(sender: UIButton) {
        if let index = walkThroughPageVC?.currentIndex {
            switch index {
            case 0...1:
                walkThroughPageVC?.forwardPage()
            case 2:
                walkThroughPageVC?.forwardPage()
            case 3:
                //第一次打开app后存储提升状态
                UserDefaults.standard.set(true, forKey: "已浏览过开始界面")
                dismiss(animated: true, completion: nil)
            default: break
            }
        }
        
        updateUI()
    }
    
    func updateUI() {
        if let index = walkThroughPageVC?.currentIndex {
            switch index {
            case 0...1:
                //判断下一页标题
                nextButton.setTitle("下一页", for: .normal)
                //判断跳过按钮是否被隐藏
                skipButton.isHidden = false
            case 2:
                nextButton.setTitle("下一页", for: .normal)
                skipButton.isHidden = false
            case 3:
                nextButton.setTitle("开始", for: .normal)
                skipButton.isHidden = true
            default: break
            }
            
            //更改页面控制的指示器
            pageControl.currentPage = index
        }
    }
    

}


extension WalkThroughVC: WalkThroughPageViewControllerDelegate {
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
}
