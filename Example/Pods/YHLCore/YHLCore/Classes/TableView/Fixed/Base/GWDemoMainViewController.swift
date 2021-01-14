//
//  GWDemoMainViewController.swift
//  GWOModuleVehicle
//
//  Created by yangshiyu on 2020/3/6.
//

import UIKit

class GWMainTableView: UITableView {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

open class GWDemoMainViewController: GWRefreshTableViewController {

     var subVC:GWExpansViewController?
    
    override open func loadView() {
        self.tableView = GWMainTableView(frame: CGRect.zero, style: UITableView.Style.plain)
        super.loadView()
    }
    
}


//scrollView Delegate handler
extension GWDemoMainViewController{
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.Fixed(scrollView: scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let isTop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if isTop {
            self.contentOffsetFixed(scrollView: scrollView)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let isTop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
            if isTop {
                self.contentOffsetFixed(scrollView: scrollView)
            }
        }
    }
    
    func Fixed(scrollView:UIScrollView) {
        //如果bottomCellOffset不变  没必要反复计算 bottomCellOffset 的值， 可以考虑优化一下
        
        let indexPath = IndexPath(item: (self.dataSource?.itemsAtSection(section: 0)!.count)!-1, section: 0)
        if let cell  = self.tableView.cellForRow(at: indexPath) {
            let rect = cell.frame
            let bottomCellOffset = rect.origin.y;
            if (scrollView.contentOffset.y >= bottomCellOffset) {
                //主视图停止滚动
                scrollView.contentOffset = CGPoint(x: 0, y: bottomCellOffset)//禁止主视图继续滚动
                self.subVC!.updateSubViewScroll(canScroll: true)//告诉子视图你可以滚了
            } else {
                let canScroll=self.subVC!.isScrollTop()//下拉时 判断子视图是否滚动到顶部 如果没有 优先滚动子视图
                if (!canScroll) {//子视图没到顶部
                    scrollView.contentOffset = CGPoint(x: 0, y: bottomCellOffset)//先别滚 等子视图滚完了你再滚
                }
            }
        }
    }
    
    func contentOffsetFixed(scrollView:UIScrollView) {
        let y = scrollView.contentOffset.y
        if y<50 {
            self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
}
