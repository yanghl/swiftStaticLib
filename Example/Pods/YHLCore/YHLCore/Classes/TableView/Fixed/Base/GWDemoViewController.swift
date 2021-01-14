//
//  GWDemoViewController.swift
//  GWOModuleVehicle
//
//  Created by yangshiyu on 2020/3/6.
//

import UIKit

class GWDemoViewController: GWRefreshTableViewController {
    //滚动相关
    var isScrolling = false
    var isValidScroll = false
    var vcCanScroll = false
    
}

extension GWDemoViewController {
    
    func startValidScroll() {
      self.isValidScroll = true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScrolling = true
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.isScrolling = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isValidScroll {
            if !self.vcCanScroll {
                scrollView.contentOffset = CGPoint.zero
            }
            if scrollView.contentOffset.y <= 0 {
                self.vcCanScroll = false
                scrollView.contentOffset = CGPoint.zero
            }
            self.tableView.showsVerticalScrollIndicator = false
        }
    }
}
