//
//  MoreTableVC.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/12/24.
//

import UIKit
import SafariServices

class MoreTableVC: UITableViewController {
    
    enum Section {
        case feedback
        case followus
    }
    
    struct LinkItem: Hashable {
        var text: String
        var link: String
        var image: String
    }
    
    var sectionContent = [[LinkItem(text: "App Store", link: "https://www.apple.com/ios/app-store/", image: "store"),
                           LinkItem(text: "Apple Open Source", link: "https://opensource.apple.com", image: "store")],
                           
                           [LinkItem(text: "Apple Developer", link: "https://developer.apple.com/documentation/", image: "store"),
                           LinkItem(text: "Xcode", link: "https://developer.apple.com/documentation/", image: "store"),
                           LinkItem(text: "Visual Studio Code", link: "https://code.visualstudio.com", image: "store"),]]
    
    lazy var dataSource = configureDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let appearance = navigationController?.navigationBar.standardAppearance {
            //将顶部导航栏背景和阴影属性重置为透明
            appearance.configureWithTransparentBackground()
            
            appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "black")!]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "black")!]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        //载入表格资料
        tableView.dataSource = dataSource
        updateSnapshot()
        
        navigationController?.hidesBarsOnSwipe = true

    }

    // MARK: - Table view data source
    
    //自定载入资源
    func configureDataSource() -> UITableViewDiffableDataSource<Section, LinkItem> {
        let cellIdentifier = "aboutcell"
        let dataSource = UITableViewDiffableDataSource<Section, LinkItem>(tableView: tableView) {
            (tableView, indexPath, linkItem) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            cell.textLabel?.text = linkItem.text
            cell.imageView?.image = UIImage(named: linkItem.image)
            
            return cell
        }
        
        return dataSource
    }
    
    //提供展示资源
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, LinkItem>()
        snapshot.appendSections([.feedback, .followus])
        snapshot.appendItems(sectionContent[0], toSection: .feedback)
        snapshot.appendItems(sectionContent[1], toSection: .followus)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取得所选的项目 WebVC取代
//        guard let linkItem = self.dataSource.itemIdentifier(for: indexPath) else {
//            return
//        }
//
//        if let url = URL(string: linkItem.link) {
//            UIApplication.shared.open(url)
//        }
        switch indexPath.section {
        case 0: performSegue(withIdentifier: "showWebView", sender: self)
        case 1: openWithSafariVC(indexPath: indexPath)
        default: break
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? WebVC,
           let indexPath = tableView.indexPathForSelectedRow,
            let linkItem = self.dataSource.itemIdentifier(for: indexPath) {
            
            destinationController.targetURL = linkItem.link
        }
    }
    
    func openWithSafariVC(indexPath: IndexPath) {
        guard let linkItem = self.dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        if let url = URL(string: linkItem.link) {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
    }


}
