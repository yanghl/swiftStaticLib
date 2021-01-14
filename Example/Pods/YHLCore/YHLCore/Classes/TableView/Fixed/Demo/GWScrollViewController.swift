//
//  GWScrollViewController.swift
//  GWOModuleVehicle
//
//  Created by yangshiyu on 2020/3/6.
//

import UIKit

open class GWScrollViewController: GWDemoMainViewController {
    
    override open func viewDidLoad() {
        
        self.subVC = GWScrollExpansViewController.init()
        self.addChild(self.subVC!)
        super.viewDidLoad()
    }
    
    override open func headerRefreshing() {
        
        var items:Array<GWCellConfig> = []
        
        let model = GWTableViewCellModel.deserialize(from: [:])
        items.append(CellConfigurator<GWDemoSubTableViewCell>(model!))
        
        let policyModel = GWDemoCellModel.init(vc: self.subVC!)
        items.append(CellConfigurator<GWDemoTableViewCell>(policyModel))
        
        let ds = GWTableViewDataSource(items: [items], sections: [""])
        self.reloadData(data: ds)
    }
}
