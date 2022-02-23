//
//  WalkThroughPageVC.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/12/23.
//

import UIKit

protocol WalkThroughPageViewControllerDelegate: AnyObject {
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkThroughPageVC: UIPageViewController {
    
    var pageHeading = ["创建您自己的美食指南", "向您展示位置", "新发现很棒的餐厅", "我是贝蒂小熊"]
    var pageImage = ["onboarding-1", "onboarding-2", "onboarding-3", "onboarding-4"]
    var pageSubHeading = ["固定您最喜欢的餐厅并创建您自己的美食指南", "在地图上搜索并找到您最喜欢的餐厅", "查找您的朋友和其他美食家共享的餐厅", "欢迎大家"]
    
    var currentIndex = 0
    
    weak var walkThroughDelegate: WalkThroughPageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        //展示第一个页面
        if let startingVC = contentViewController(at: 0) {
            setViewControllers([startingVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    //点击下一页按钮实现
    func forwardPage() {
        currentIndex += 1
        if let nextVC = contentViewController(at: currentIndex) {
            setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
}


extension WalkThroughPageVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkThroughContentVC).index
        index -= 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkThroughContentVC).index
        index += 1
        
        return contentViewController(at: index)
    }
    
    func contentViewController(at index: Int) -> WalkThroughContentVC? {
        if index < 0 || index >= pageHeading.count {
            return nil
        }
        
        //建立新的视图控制器传送资料
        let storyboard = UIStoryboard(name: "OnBoard", bundle: nil)
        if let pageContentVC = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentVC") as? WalkThroughContentVC {
            pageContentVC.imageFile = pageImage[index]
            pageContentVC.heading = pageHeading[index]
            pageContentVC.subHeading = pageSubHeading[index]
            pageContentVC.index = index
            
            return pageContentVC
        }
        
        return nil
        
    }
    
    
}

extension WalkThroughPageVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if  completed {
            if let contenViewController = pageViewController.viewControllers?.first as? WalkThroughContentVC {
                currentIndex = contenViewController.index
                walkThroughDelegate?.didUpdatePageIndex(currentIndex: contenViewController.index)
            }
        }
    }
}
