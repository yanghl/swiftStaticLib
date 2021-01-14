//
//  GWTableViewResponse.swift
//  GWUtilCore
//
//  Created by yangshiyu on 2020/2/13.
//

import UIKit
import HandyJSON
import Moya
import Alamofire

open class GWPageInfo:HandyJSON {
    
    open var pageNum = 0 //当前页
    open var pageSize = 0 // 每页条数
    open var totalSize = 0 //总条数
    open var totalPage = 0 //总页数
    open var canDownPage:Bool{
        return totalPage>pageNum
    }
    required public init() {}
}

open class GWTableViewResponse: HandyJSON {
    required public init() {}
    
    open var originData:Any? //原始数据
    open var responseData:Any? //
    open var statusCode:String?
    open var page:GWPageInfo?
    open var message:String?
    open var error:Error?
    
    //Any 为临时类型
    static func convertResponse(_ result:Any) -> GWTableViewResponse {
        let rp = GWTableViewResponse()
        
        return rp
    }
}


