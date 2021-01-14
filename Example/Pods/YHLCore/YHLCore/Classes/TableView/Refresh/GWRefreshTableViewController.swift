//
//  GWRefreshTableViewController.swift
//  GWUtilCore
//
//  Created by yangshiyu on 2020/2/13.
//

import UIKit
import MJRefresh

open class GWRefreshTableViewController: GWTableViewController {
    
    open var requestModel:GWRequestModel?
    
    open var didSupportHeaderRefreshing:Bool=false
    open var didSupportFooterRefreshing:Bool=false
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        if didSupportHeaderRefreshing {
            self.tableView.mj_header = refreshHeader()
        }
        
        if didSupportFooterRefreshing {
            self.tableView.mj_footer = refreshFooter()
        }
        
        //初始化分页model
        self.loadRequestModel()
        //
        headerRefreshing()
        
    }

    
    open func loadRequestModel(){
        self.requestModel = GWRequestModel()
    }
    
     open func headerRefreshing() {
        self.requestModel?.requestType = .pageUp
        self.requestModel?.requestWithType(completionHandler: {
            [weak self]
            (response) in
            if response.error == nil {
                self?.responseWithModel(dataSource: self?.requestModel?.dataSource)
            }else{
                self?.updateEmptyViewWithErrorCode(error: response.error)
            }
            self?.updateHeaderWhenRequestFinished()
        })
    }
    
    open func footerRefreshing() {
        self.requestModel?.requestType = .pageDown
        self.requestModel?.requestWithType(completionHandler: {
            [weak self]
            (response) in
            if response.error == nil {
                self?.responseWithModel(dataSource: self?.requestModel?.dataSource)
            }else{
                self?.updateEmptyViewWithErrorCode(error: response.error)
            }
            self?.updateFooterWhenRequestFinished()
        })
    }
    func refreshHeader() -> MJRefreshNormalHeader {
//    func refreshHeader() -> GWAnimationRefreshHeader {
       return MJRefreshNormalHeader {
            [weak self]  in
            self?.headerRefreshing()
        }
        
//       return GWAnimationRefreshHeader {
//        [unowned self]  in
//            self.headerRefreshing()
//        }
    }
    
    func refreshFooter() -> MJRefreshFooter {
        let footer = MJRefreshAutoNormalFooter {
            [weak self]  in
            self?.footerRefreshing()
        }
        
        footer.setTitle("我也是有底线的～", for: .noMoreData)
        footer.isHidden = true
        return footer
    }
    
    open func beginHeaderRefreshing()  {
        
        self.tableView.mj_header?.beginRefreshing()
    }
    open func endHeaderRefreshing()  {
        self.tableView.mj_header?.endRefreshing()
    }
    open func beginFooterRefreshing()  {
        self.tableView.mj_footer?.beginRefreshing()
    }
    open func endFooterRefreshing()  {
        self.tableView.mj_footer?.endRefreshing()
    }
    
    open func updateHeaderWhenRequestFinished() {
        self.endHeaderRefreshing()
        self.tableView.mj_footer?.resetNoMoreData()
        //当没有数据的时候 隐藏footer
        if self.requestModel?.items.count==0 || !self.requestModel!.canPageDown {
            self.tableView.mj_footer?.isHidden=true
        }else{
            self.tableView.mj_footer?.isHidden=false
        }
    }
    open func updateFooterWhenRequestFinished() {
        self.endFooterRefreshing()
        if !self.requestModel!.canPageDown {
            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
    }
    
    open func updateEmptyViewWithErrorCode(error:Error?) {
        
    }
    
    open func responseWithModel(dataSource:GWTableViewDataSource?)  {
        self.reloadData(data: dataSource)
    }
    
    open func setRefreshFooterStatus(status:MJRefreshState) {
        
    }

}

