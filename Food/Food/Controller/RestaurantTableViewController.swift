//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/10/11.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController {
    
    //空文件的背景显示
    @IBOutlet var emptyRestaurantView: UIView!
    
    lazy var dataSource = configureDataSource()
    
    var restaurants: [Restaurant] = []
    
    //    var restaurants: [Restaurant] = [
    //        Restaurant(name: "西湖", location: "中国浙江省杭州市西湖区龙井路1号", type: "ChenCan", image: "barrafina", isFavorite: false, phone: "032-324242", description: "正在寻找美味的早餐餐厅和咖啡？ 这个地方是给你的。 我们每天早上 6:30 开门，晚上 9 点关门。 我们提供浓缩咖啡和浓缩咖啡饮品，例如卡布奇诺咖啡、拿铁咖啡、短笛等等。 过来享受一顿美餐.")
    //    ]
    
    //存取结果声明
    var fetcResultController: NSFetchedResultsController<Restaurant>!
    
    var searchController: UISearchController!
    
    //MARK: 打开App首先展示传送page整个页面
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "已浏览过开始界面") {
            return
        }
    
        let storyboard = UIStoryboard(name: "OnBoard", bundle: nil)
        if let walkThroughVC = storyboard.instantiateViewController(withIdentifier: "WalkThroughVC") as? WalkThroughVC {
            present(walkThroughVC, animated: true, completion: nil)
        }
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Thread.sleep(forTimeInterval: 3.0)
        
        //MARK: searchbar栏
        searchController = UISearchController(searchResultsController: nil)
        //强制显示搜索框 有bug这句
        tableView.tableHeaderView = searchController.searchBar
        //非强制显示搜索框
        //self.navigationItem.searchController = searchController
        self.searchController.searchBar.placeholder = "搜索"
        //搜索结果更新
        searchController.searchResultsUpdater = self
        //底部内容在搜索期间变成灰色状态
        searchController.obscuresBackgroundDuringPresentation = false
        
        //启用大标题foodPin
        //navigationController?.navigationBar.prefersLargeTitles = true
        //隐藏滑动时顶部的bar显示
        navigationController?.hidesBarsOnSwipe = true
        //隐藏返回按钮上的文字
        navigationItem.backButtonTitle = "返回"
        
//        //创建snapshot并填充数据 建立CoreData数据后删除 重新创建一个方法
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
//        snapshot.appendSections([.all])
//        snapshot.appendItems(restaurants, toSection: .all)
//
//        dataSource.apply(snapshot, animatingDifferences: false)
        
        //MARK: 自定义导航栏外观
        if let appearance = navigationController?.navigationBar.standardAppearance {
            //将顶部导航栏背景和阴影属性重置为透明
            //appearance.configureWithTransparentBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "black")!]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        //tableView.backgroundColor = UIColor(named: "oneColor")
        //设置表视图的数据源
        tableView.dataSource = dataSource
        //取消分隔符
        tableView.separatorStyle = .none
        //创建快照并填充数据
        fetchRestaurantData()
    
        //单元格边距的可读内容
        tableView.cellLayoutMarginsFollowReadableWidth = true
        //去掉右边的滚动条
        tableView.showsVerticalScrollIndicator = false
        
        //空试图显示
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
        
    }
    
    
    //解决隐藏滑动时顶部的bar显示再次从其他页面返回时无法隐藏的bug
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    //MARK: CoreData数据
    func fetchRestaurantData(searchText: String = "") {
        //从数据存储中获取数据
        let fetcRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        
        //searchbar的内容筛选
        if !searchText.isEmpty {
            fetcRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
        }
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetcRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetcResultController = NSFetchedResultsController(fetchRequest: fetcRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetcResultController.delegate = self
            
            do {
                try fetcResultController.performFetch()
                
                updateSnapshot()
            } catch {
                print(error)
            }
        }
    }
    
    func updateSnapshot(animatingChange: Bool = false) {
        
        if let fetchedObjects = fetcResultController.fetchedObjects {
            restaurants = fetchedObjects
        }
        
        //创建快照并填充数据
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
        
        //更新背景视图
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
    }
    
    //MARK: 使用UITableViewDiffableDataSource定义表格
    func configureDataSource() -> UITableViewDiffableDataSource<Section, Restaurant> {
        
        //ReataurantDiffableDataSource 这里这个restaurant写错了
        let dataSource = ReataurantDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, restaurant in
                let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath) as! RestaurantTableViewCell
                
                cell.nameLabel.text = restaurant.name
                cell.locationLabel.text = restaurant.location
                cell.typeLabel.text = restaurant.type
                cell.thumbnailImageView.image = UIImage(data: restaurant.image)
                cell.favoriteImageView.isHidden = restaurant.isFavorite ? false : true
                
                return cell
            }
        )
        
        return dataSource
    }
    
    //MARK: 右滑删除和分享
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //在搜索期间停止删除分享操作
        if searchController.isActive {
            return UISwipeActionsConfiguration()
        }
        
        //选取
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            
            return UISwipeActionsConfiguration()
        }
        
        //删除操作
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { (action, sourceView, completionHandler) in
          
//            var snapshot = self.dataSource.snapshot()
//            snapshot.deleteItems([restaurant])
//            self.dataSource.apply(snapshot, animatingDifferences: true)
            
            //coreData删除列表
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                //删除项目
                context.delete(restaurant)
                appDelegate.saveContext()
                //更新视图
                self.updateSnapshot(animatingChange: true)
            }
            
            //操作完成处理器来取消动作按钮
            completionHandler(true)
        }
        
        //分享操作
        let shareAction = UIContextualAction(style: .normal, title: "分享") {(action, sourceView, completionHandler) in
            let defaultText = "just checking in at" + restaurant.name
            let activityController: UIActivityViewController
            
            if let imageToshare = UIImage(data: restaurant.image) {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToshare], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            //iPad错误处理
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
            
        }
        
        //删除效果的背景和图片设置
        deleteAction.backgroundColor = UIColor.systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        shareAction.backgroundColor = UIColor.systemOrange
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        return swipeConfiguration
        
        
    }
    
    //MARK: 左滑收藏
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoriteAction = UIContextualAction(style: .destructive, title: "") {(action, sourceView, completionHandler) in
            
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            
            cell.favoriteImageView.isHidden = self.restaurants[indexPath.row].isFavorite
            
            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
            
            //调用完成处理程序以关闭操作按钮
            completionHandler(true)
        }
        
        //配置滑动动作
        favoriteAction.backgroundColor = UIColor.systemRed
        favoriteAction.image = UIImage(systemName: self.restaurants[indexPath.row].isFavorite ? "heart.slash.fill" : "heart.fill")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [favoriteAction])
        
        return swipeConfiguration
        
    }
    
    //MARK: 传送资料进入RestaurantDetailVC界面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showRestaurantDetail" {
            if  let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = self.restaurants[indexPath.row]
                //进入界面隐藏底部导航栏
                destinationController.hidesBottomBarWhenPushed = true
            }
        }
    }
    
    //回退segue给tableView
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

//新增删除移动更新
extension RestaurantTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
    }
}

//searchbar文字搜索结果
extension RestaurantTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        fetchRestaurantData(searchText: searchText)
    }
}
