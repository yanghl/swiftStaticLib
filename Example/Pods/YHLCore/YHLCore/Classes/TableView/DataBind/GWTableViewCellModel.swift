//
//  GWTableViewCellModel.swift
//  superora_ios
//
//  Created by yangshiyu on 2020/2/7.
//  Copyright © 2020 xue. All rights reserved.
//

import UIKit
import HandyJSON
//cell数据更新协议
public protocol GWCellUpdata {
    associatedtype ViewData:Equatable
    func update(viewData: ViewData,indexPath:IndexPath)
}
//
public protocol GWCellConfig {
    
    var reuseIdentifier: String { get }
    var className: AnyClass { get }
    var cacheHeight:CGFloat { get set}
    var isRegisterByClass:Bool {get set}
    
    func update(cell: UITableViewCell,indexPath:IndexPath)
    func calculateHeight() -> CGFloat
    func isEqual(_ model:GWCellConfig) -> Bool
}
//
public typealias GWCellHandleBlock = (_ cell:UITableViewCell?,_ indexpath:IndexPath?,_ model:GWTableViewCellModel?,_ data:Any?) -> Void

//viewmodel 基类
open class GWTableViewCellModel: NSObject,HandyJSON {
    public var cacheHeight:CGFloat = 0
    public var className:AnyClass
    public var isRegisterByClass:Bool = false
    public var handleBlock:GWCellHandleBlock?
    
    required override public init() {
        self.className = UITableViewCell.self
        super.init()
    }
    
    init(className:AnyClass) {
        self.className=className
        super.init()
    }
    
    func calculateHeight() -> CGFloat {
        return cacheHeight
    }
    
    static public func parse<T:GWTableViewCellModel> (items:Array<Any>) -> [T]?{
        let models = JSONDeserializer<T>.deserializeModelArrayFrom(array: items)
        return models as? [T]
    }
    
    static public func parse<T:GWTableViewCellModel>(item:Dictionary<String,Any>) -> T? {
        return T.deserialize(from: item)
    }
}


open class CellConfigurator<Cell>:Equatable where Cell: GWCellUpdata, Cell: UITableViewCell {
    
    public static func == (lhs: CellConfigurator<Cell>, rhs: CellConfigurator<Cell>) -> Bool {
        return true
    }
    
    public let viewData: Cell.ViewData
    public let reuseIdentifier: String = NSStringFromClass(Cell.self)
    public let className: AnyClass = Cell.self
    public var cacheHeight:CGFloat = 0
    public var isRegisterByClass:Bool = false
    
    public func update(cell: UITableViewCell, indexPath: IndexPath) {
        if let cell = cell as? Cell {
            cell.update(viewData: viewData, indexPath: indexPath)
        }
    }
    public func calculateHeight() -> CGFloat {
        return cacheHeight
    }
    
    public init(_ viewData:GWTableViewCellModel) {
        self.viewData = viewData as! Cell.ViewData
    }
    
    static public func parses<T:GWTableViewCellModel>(items:[T?]) -> [CellConfigurator<Cell>] {
        var configs:[CellConfigurator<Cell>] = []
        for item in items {
            let config = CellConfigurator<Cell>(item!)
            configs.append(config)
        }
        return configs
    }
}

extension CellConfigurator: GWCellConfig {
    public func isEqual(_ model: GWCellConfig) -> Bool {
        if let cellModel:CellConfigurator<Cell> = model as? CellConfigurator<Cell> {
            return self.viewData == cellModel.viewData && self == cellModel
        }
        return false
    }
}
