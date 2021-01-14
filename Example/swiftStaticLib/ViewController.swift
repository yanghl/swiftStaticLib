//
//  ViewController.swift
//  swiftStaticLib
//
//  Created by 272789124@qq.com on 01/14/2021.
//  Copyright (c) 2021 272789124@qq.com. All rights reserved.
//

import UIKit
import swiftStaticLib

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let a = staticLib()
        
        a.printInstanceFun()
        
        staticLib.printStaticFun()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

