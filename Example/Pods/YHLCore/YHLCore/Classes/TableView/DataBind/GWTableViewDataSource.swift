//
//  GWTableViewDataSource.swift
//  superora_ios
//
//  Created by yangshiyu on 2020/2/7.
//  Copyright © 2020 xue. All rights reserved.
//

import UIKit

open class GWTableViewDataSource: NSObject,UITableViewDataSource {
    
    public var sections:Array<String>
    public var items:Array<Array<GWCellConfig>>
    
    //单组初始化方法
    public init(items:Array<GWCellConfig>) {
        self.items = [items]
        self.sections = [""]
    }
    //多组初始化方法
    public init(items:Array<Array<GWCellConfig>>,sections:Array<String>) {
        assert(items.count == sections.count,"items数组必须和sections数组长度一致")

        self.items = items
        self.sections = sections
    }
    
    public func isEmpty() -> Bool {
        var empty = true
        for item in self.items {
            if item.count > 0 {
                empty = false //有一个不为空 即不为空
            }
        }
        return empty
    }
    
    public func itemsAtSection(section:Int) -> Array<GWCellConfig>? {
        if items.count>section  {
            return items[section]
        }
        return nil
    }
    
    public func itemAtIndexPath(indexPath:IndexPath) -> GWCellConfig? {
        if items.count>indexPath.section {
            let models = items[indexPath.section]
            if models.count>indexPath.row {
                return models[indexPath.row]
            }
        }
        return nil
    }
    
    public func itemAtIndexPath<T>(indexPath:IndexPath) -> CellConfigurator<T>? {
        let config = self.itemAtIndexPath(indexPath: indexPath)
        if let model = config as? CellConfigurator<T> {
            return model
        }else{
            return nil
        }
    }
    
    public func viewDataAtIndexPath<T>(indexPath:IndexPath,cell:T.Type) -> (CellConfigurator<T>?,Any?) {
        let config = self.itemAtIndexPath(indexPath: indexPath)
        if let model = config as? CellConfigurator<T> {
            return (model,model.viewData)
        }else{
            return (nil,nil)
        }
    }
    
    public func indexPathOfItem(model:GWCellConfig) -> NSIndexPath? {
        var section:Int = -1;
        var row:Int = -1;
        
        for data in items {
            section+=1
            for item in data {
                 row+=1
                if item.isEqual(model) {
                    break
                }
            }
        }
        
        if section != -1 && row != -1 {
            return NSIndexPath.init(row: row, section: section)
        }else{
            return nil
        }
    }
    
    public func addNewSection(section:String,item:Array<GWCellConfig>) {
        sections.append(section)
        items.append(item)
    }
    
    public func insertSection(section:String,item:Array<GWCellConfig>,index:Int) {
        sections.insert(section, at: index)
        items.insert(item, at: index)
    }
    
    public func insertSection(item:GWCellConfig ,path:IndexPath) {
        if items.count < path.section {
            return
        }
        
        var models = items[path.section]
        if models.count<path.row {
            return;
        }
        
        models.insert(item, at: path.row)
    }
    
    public func removeItem(path:IndexPath) {
        if items.count < path.section {
            return
        }
        var models = items[path.section]
        if models.count<path.row || models.count==0 {
            return;
        }
        models.remove(at: path.row)
        items[path.section]=models
    }
    
    public func removeSection(section:Int)  {
        if items.count < section || items.count==0 {
            return
        }
        items.remove(at: section)
    }
    
    public func removeItemsOfSection(section:Int) {
        if items.count < section || items.count==0 {
            return
        }
        items[section].removeAll()
    }
    
    public func appendItems(item:Array<GWCellConfig>,section:Int) {
        if sections.count < section+1 {
            return
        }
        items[section].append(contentsOf: item)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections.count > section {
            return sections[section]
        }
        return nil
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= 0 && section < items.count {
            return items[section].count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemAtIndexPath(indexPath: indexPath)!
        registerClass(tableView: tableView, cellClass: item.className, identify: item.reuseIdentifier, isRegisterByClass: item.isRegisterByClass)
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier, for: indexPath)
        item.update(cell: cell, indexPath: indexPath)
        return cell
    }
    
    public func registerClass(tableView:UITableView, cellClass:AnyClass,identify:String,isRegisterByClass:Bool) {
        if isRegisterByClass {
            tableView.register(cellClass, forCellReuseIdentifier: identify)
        }else{
            let podName:String = NSStringFromClass(cellClass).split(separator: ".").first!.description
            let path = Bundle.main.path(forResource: "Frameworks/"+podName+".framework/"+podName, ofType: "bundle")
            var bundle:Bundle?
            if path == nil {
                let url = Bundle(for: cellClass.self).url(forResource: podName, withExtension: "bundle")
                if url == nil {
                    bundle = Bundle(for: cellClass.self)
                }else{
                    bundle = Bundle(url: url!)
                }
            }else{
                let tempPath = Bundle.main.path(forResource: "Frameworks/"+podName+".framework/"+podName+".bundle/"+String(describing: cellClass.self) + ".nib", ofType: nil)
                if tempPath == nil {
                    bundle = Bundle(for: cellClass.self)
                }else{
                    bundle = Bundle.init(path: path!)!
                }
            }
            let nib = UINib.init(nibName: String(describing: cellClass.self), bundle: bundle)
            tableView.register(nib, forCellReuseIdentifier: identify)
        }
    }
    
}
