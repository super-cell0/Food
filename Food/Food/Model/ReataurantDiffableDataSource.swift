//
//  ReataurantDiffableDataSource.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/10/11.
//

import UIKit

enum Section {
    case all
}

//往左滑动删除
class ReataurantDiffableDataSource: UITableViewDiffableDataSource<Section, Restaurant> {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


}
