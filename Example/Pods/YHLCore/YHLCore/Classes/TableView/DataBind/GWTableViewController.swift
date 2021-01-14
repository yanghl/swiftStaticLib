//
//  GWTableViewController.swift
//  superora_ios
//
//  Created by yangshiyu on 2020/2/7.
//  Copyright © 2020 xue. All rights reserved.
//


import UIKit
import SnapKit
import UITableView_FDTemplateLayoutCell

open class GWTableViewController: BaseViewController,UITableViewDelegate {
    
    open var tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
    open var isAutolayout = true
    open var dataSource:GWTableViewDataSource?
    open var xibData:Array<String>?
    //
    open override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        if #available(iOS 11.0, *) {
        } else {
            self.tableView.estimatedRowHeight = 100
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if self.responds(to: #selector(setter: edgesForExtendedLayout)) {
            self.edgesForExtendedLayout = [] 
        }
        self.extendedLayoutIncludesOpaqueBars = false

        tableView.delegate=self
        tableView.separatorStyle = .none
        
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.tableView.frame == CGRect.zero {
            self.tableView.frame=self.view.bounds
        }
    }
    
    public func reloadData(data:GWTableViewDataSource?) {
        if data == nil || data!.isEmpty() {
            self.showEmptyView()
            self.hiddenErrorView()
            dataSource=nil
            tableView.dataSource=nil
            tableView.reloadData()
        }else{
            self.hiddenEmptyView()
            self.hiddenErrorView()
            dataSource=data
            tableView.dataSource=dataSource
            tableView.reloadData()
        }
    }
    
    override open func didReceiveMemoryWarning() {
        if view.window == nil && self.isViewLoaded {
            //暂不处理
//            self.view = nil
        }
    }

    //MARK: tableView delegate
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var model = self.dataSource!.itemAtIndexPath(indexPath: indexPath)!
        
        if model.cacheHeight > 0 {
            return model.cacheHeight
        }
        
        if isAutolayout {
            let podName:String = NSStringFromClass(model.className).split(separator: ".").first!.description
            let path = Bundle.main.path(forResource: "Frameworks/"+podName+".framework/"+podName, ofType: "bundle")
            var bundle:Bundle?
            if path == nil {
                let url = Bundle(for: model.className.self).url(forResource: podName, withExtension: "bundle")
                if url == nil {
                    bundle = Bundle(for: model.className.self)
                }else{
                    bundle = Bundle(url: url!)
                }
            }else{
                let tempPath = Bundle.main.path(forResource: "Frameworks/"+podName+".framework/"+podName+".bundle/"+String(describing: model.className.self) + ".nib", ofType: nil)
                if tempPath == nil {
                    bundle = Bundle(for: model.className.self)
                }else{
                    bundle = Bundle.init(path: path!)!
                }
            }
            let nib = UINib.init(nibName: String(describing: model.className.self), bundle: bundle)
            tableView.register(nib, forCellReuseIdentifier: String(describing: model.reuseIdentifier))
            let height = tableView.fd_heightForCell(withIdentifier: model.reuseIdentifier, cacheBy: indexPath, configuration: { cell in
                model.update(cell: cell as! UITableViewCell, indexPath: indexPath)
            })
            model.cacheHeight=height
            return height
        }else{
            return model.calculateHeight()
        }
    }
}
