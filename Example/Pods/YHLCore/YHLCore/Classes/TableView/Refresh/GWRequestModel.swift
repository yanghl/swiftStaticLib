//
//  GWRequestModel.swift
//  GWUtilCore
//
//  Created by yangshiyu on 2020/2/13.
//

import UIKit

public enum GWRequestType:Int {
    case pageUp = 0 //下拉刷新
    case pageDown
    case cache
    
}
open class GWRequestModel: NSObject {
    open var cacheKey:String?
    open var modulePath:String?
    open var detailPath:String?
    open var parameter:Dictionary<String,Any> = [:]
    open var headerFields:Dictionary<String,String>?
    open var canPageDown:Bool = false
    open var currentPage:Int = 0
    open var dataSource:GWTableViewDataSource?
    open var requestType:GWRequestType = .pageUp
    open var items:Array<GWCellConfig> = []
    open var headerItems:Array<GWCellConfig> = [] //带有头部数据的分页列表 可在此保存头部数据
    open var parser:((_ response:GWTableViewResponse) -> Array<GWCellConfig>?)?
    
    open func requestWithType(completionHandler: @escaping(_ dict:GWTableViewResponse) -> ()) {
        guard let modulePath = modulePath , let detailPath = detailPath else {
            fatalError("域名不能为空")
        }
        var tableReponse:GWTableViewResponse?
//        GWNetworkManager.gwPostRequest(modulePath: modulePath, detailPath: detailPath, parms: self.customParam(param: self.parameter),headerParms:self.headerFields , successCallBack: { (result) in
//            
//            tableReponse = GWTableViewResponse.convertResponse(result)
//            self.canPageDown=tableReponse?.page?.canDownPage ?? false
//            self.currentPage=tableReponse?.page?.pageNum ?? 0
//            let data = self.parser!(tableReponse!)
//            if data != nil {
//                if self.requestType == .pageDown {
//                    self.pageDownDatasource(datas: data!)
//                }else if self.requestType == .pageUp {
//                    self.pageUpDatasource(datas: data!)
//                }
//            }
//            completionHandler(tableReponse!)
//        }) { (er) in
//            tableReponse = GWTableViewResponse()
//            tableReponse?.error = er
//            completionHandler(tableReponse!)
//        }
    }
    //如果每次请求有动态参数传入 请重写此方法
    //因为每个项目 分页相关参数规则不一样 所以GWRequestModel不处理分页逻辑
    open func customParam(param:Dictionary<String,Any>?) -> Dictionary<String,Any>? {
        return param
    }
    
    open func pageDownDatasource(datas:Array<GWCellConfig>) {
        if datas.count > 0 {
            self.items+=datas
            let array = self.headerItems + self.items
            self.dataSource = GWTableViewDataSource(items: [array], sections: [""])
        }
    }
    
    open func pageUpDatasource(datas:Array<GWCellConfig>) {
        self.items = datas
        let array = self.headerItems + self.items
        self.dataSource = GWTableViewDataSource(items: [array], sections: [""])
    }
}


