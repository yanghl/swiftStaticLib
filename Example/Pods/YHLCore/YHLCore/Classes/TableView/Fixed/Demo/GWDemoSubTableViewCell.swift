//
//  GWDemoSubTableViewCell.swift
//  YHLCore
//
//  Created by yangshiyu on 2020/7/30.
//

import UIKit

class GWDemoSubTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
extension GWDemoSubTableViewCell: GWCellUpdata{
    
    typealias ViewData = GWTableViewCellModel
    func update(viewData: GWTableViewCellModel, indexPath: IndexPath) {
        
    }
}
