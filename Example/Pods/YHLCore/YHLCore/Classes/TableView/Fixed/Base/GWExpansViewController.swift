//
//  GWExpansViewController.swift
//  GWOModuleVehicle
//
//  Created by yangshiyu on 2020/3/6.
//

import UIKit

class GWExpansViewController: GWContainerViewController {

    var contentOffset:CGPoint?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllers.forEach { (vc) in
            let subVc = vc as! GWDemoViewController
            subVc.startValidScroll()
        }
    }
    
    open override func setupUI() {
         super.setupUI()
         
         
         self.navigationView.borderColor=UIColor(hex: 0x4533B5)!
         self.navigationView.normalTextColor=UIColor(hex: 0x666666)!
         self.navigationView.selectedTextColor=UIColor(hex: 0x000000)!
         self.navigationView.selectedTextFont = UIFont.systemFont(ofSize: 22, weight: .bold)
         self.navigationView.normalTextFont = UIFont.systemFont(ofSize: 14)
         
         self.navigationView.backgroundColor = UIColor(hex: 0xFCFDFE)
         
     }
    
    open override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      
      let size = self.view.frame.size
      self.navigationView.frame=CGRect(x: 0, y: 0, width: size.width, height: self.navigationView.customHeight)
      self.flowLayout.itemSize = CGSize(width: size.width, height: size.height-self.navigationView.frame.maxY)
      self.collectionView.frame = CGRect(x: 0, y: self.navigationView.frame.maxY, width: size.width, height: size.height-self.navigationView.frame.maxY)
    }
    
    
    

    func updateSubViewScroll(canScroll:Bool)  {
        let vc = self.currentController as! GWDemoViewController
        vc.vcCanScroll = canScroll
        if !canScroll {
            vc.tableView.contentOffset = CGPoint.zero
        }
    }
    
    func isScrollTop() -> Bool {
        let vc = self.currentController as! GWDemoViewController
        return vc.tableView.contentOffset == CGPoint.zero
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.x) % Int(kScreenWidth) == 0 {
            self.contentOffset=scrollView.contentOffset;
        }
    }

}
