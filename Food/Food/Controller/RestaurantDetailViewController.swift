//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/11/14.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    
    var restaurant: Restaurant!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderVC!
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //去掉HeaderView大标题
        navigationController?.navigationBar.prefersLargeTitles = false
        //不隐藏滑动时顶部的bar显示
        navigationController?.hidesBarsOnSwipe = false
        
        //将视图移动到顶部
        //tableView.contentInsetAdjustmentBehavior = .never
        
        //取消分隔符
        tableView.separatorStyle = .none
        //去掉左边的滚动条
        tableView.showsVerticalScrollIndicator = false
        
        //设置顶部视图内容
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        headerView.headerImageView.image = UIImage(data: restaurant.image)
        
        //收藏按钮显示
//        let heartImage = restaurant.isFavorite ? "heart.fill" : "heart"
//        headerView.heartButton.tintColor = restaurant.isFavorite ? .systemPink : .white
//        headerView.heartButton.setImage(UIImage(systemName: heartImage), for: .normal)
        //创建快照并填充数据
        configureFavoriteIcon()
        
        //配置资源
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //显示评分
        if let rating = restaurant.rating {
            headerView.ratingImageView.image = UIImage(named: rating.image)
        }
        
        
    }
  
    
    //解决隐藏滑动时顶部的bar显示转到其他页面返回时隐藏该页面的顶部bar的显示的bug
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: 传送地图界面和点评资料
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showMap":
            let destinationController = segue.destination as! MapVC
            
            destinationController.restaurant = restaurant
            
        case "showReview":
            let destinationCortroller = segue.destination as! ReviewVC
            
            destinationCortroller.restaurant = restaurant
            
        default: break
        }
    }
    
    //退出界面--使用segue退出界面  连接的时候在Exit
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    //表情--回退Segue资料传送
    @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        dismiss(animated: true, completion: {
            
            if let rating = Restaurant.Rating(rawValue: identifier) {
                self.restaurant.rating = rating
                self.headerView.ratingImageView.image = UIImage(named: rating.image)
                
                //coreData存储评分 将更改保存到数据库
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    appDelegate.saveContext()
                }
                
                let scaleTransfrom = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                self.headerView.ratingImageView.transform = scaleTransfrom
                self.headerView.ratingImageView.alpha = 0
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                    self.headerView.ratingImageView.transform = .identity
                    self.headerView.ratingImageView.alpha = 1
                }, completion: nil)
            }
        })
    }
    
    //收藏按钮
    @IBAction func saveFavorite() {
        restaurant.isFavorite.toggle()
        
        configureFavoriteIcon()
        
        //将更改保存到数据库
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appDelegate.saveContext()
        }
    }
    
    func configureFavoriteIcon() {
        let heartImage = restaurant.isFavorite ? "heart.fill" : "heart"
        let heartIconConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        favoriteBarButton.image = UIImage(systemName: heartImage, withConfiguration: heartIconConfiguration)
        favoriteBarButton.tintColor = restaurant.isFavorite ? .systemPink : .systemBlue
    }
    
    
}


extension RestaurantDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            
            cell.descriptionLabel.text = restaurant.summary
            //取消选中状态的灰色状态
            cell.selectionStyle = .none
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTwoTableViewCell.self), for: indexPath) as! RestaurantDetailTwoTableViewCell
            
            cell.column1TitleLabel.text = "Address"
            cell.column1TextLabel.text = restaurant.location
            
            cell.column2TitleLabel.text = "Phone"
            cell.column2TextLabel.text = restaurant.phone
            
            cell.selectionStyle = .none
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMC.self), for: indexPath) as! RestaurantDetailMC
            
            cell.configureMapSdk(location: restaurant.location)
            cell.selectionStyle = .none
            
            return cell
            
        default:
            fatalError("无法实例化详细视图控制器的表视图单元格")
        }
    }
    
    
}


