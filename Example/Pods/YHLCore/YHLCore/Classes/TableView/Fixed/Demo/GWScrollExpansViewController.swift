//
//  GWScrollExpansViewController.swift
//  GWOModuleVehicle
//
//  Created by yangshiyu on 2020/3/6.
//

import UIKit
import URLNavigator

class GWScrollExpansViewController: GWExpansViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func addChildControllers() -> Array<UIViewController> {
        return  [GWScrollDemoViewController(navigator: YHLNavigator.shared,param: ["title":"R1"]),GWScrollDemoViewController(navigator: YHLNavigator.shared,param: ["title":"R1"])]
    }
}
