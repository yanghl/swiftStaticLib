//
//  GWDemoTableViewCell.swift
//  GWOModuleVehicle
//
//  Created by yangshiyu on 2020/3/6.
//

import UIKit
import HandyJSON

func visibleViewHeight() -> CGFloat {
    let navHeight    = CGFloat(kNavBarHeight)
    let tabHeight    = CGFloat(kTabBarHeight)
    return kScreenHeight-navHeight-tabHeight
}

class GWDemoCellModel: GWTableViewCellModel {
    var vc:UIViewController!
    convenience init(vc:UIViewController) {
        self.init()
        self.vc = vc
        self.className   = GWDemoTableViewCell.self
        self.cacheHeight = visibleViewHeight()
    }
}


class GWDemoTableViewCell: UITableViewCell {

}

extension GWDemoTableViewCell: GWCellUpdata{
    
    typealias ViewData = GWDemoCellModel
    func update(viewData: GWDemoCellModel, indexPath: IndexPath) {
        let newsModel = viewData
        let view = newsModel.vc.view
        self.contentView.addSubview(view!)
        view?.layer.cornerRadius=10
        view?.clipsToBounds=true
        view?.snp_makeConstraints({ (make) in
            make.left.equalTo(self.contentView.snp_left).offset(15)
            make.right.equalTo(self.contentView.snp_right).offset(-15)
            make.top.bottom.equalTo(self.contentView)
            make.height.equalTo(visibleViewHeight())
        })
    }
}

