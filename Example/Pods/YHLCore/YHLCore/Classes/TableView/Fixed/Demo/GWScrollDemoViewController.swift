//
//  GWScrollDemoViewController.swift
//  GWOModuleVehicle
//
//  Created by yangshiyu on 2020/3/6.
//

import UIKit

class GWScrollDemoViewController: GWDemoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func headerRefreshing() {
        
        var items:Array<GWCellConfig> = []
        
        let config = CellConfigurator<GWDemoSubTableViewCell>(GWTableViewCellModel.deserialize(from: [:])!)
        items.append(config)
        
        
        let config2 = CellConfigurator<GWDemoSubTableViewCell>(GWTableViewCellModel.deserialize(from: [:])!)
        items.append(config2)
        
        let config1 = CellConfigurator<GWDemoSubTableViewCell>(GWTableViewCellModel.deserialize(from: [:])!)
        items.append(config1)
        
        let config3 = CellConfigurator<GWDemoSubTableViewCell>(GWTableViewCellModel.deserialize(from: [:])!)
        items.append(config3)
        
        let config4 = CellConfigurator<GWDemoSubTableViewCell>(GWTableViewCellModel.deserialize(from: [:])!)
        items.append(config4)
        
        let ds = GWTableViewDataSource(items: [items], sections: [""])
        self.reloadData(data: ds)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item:CellConfigurator<GWDemoSubTableViewCell> = self.dataSource?.itemAtIndexPath(indexPath: indexPath) {
            let height = item.viewData.cacheHeight
            print(height)
        }
    }
}
