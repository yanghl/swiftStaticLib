//
//  EmptyDataView.swift
//  EmptyList
//
//  Created by eme on 2017/3/30.
//  Copyright © 2017年 Icy. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/// 列表数据为空时显示的界面
open class EmptyDataView: UIView {
    
    /// UI控件
    public var logo_ImgV = UIImageView()
    public var desc_Lb = UILabel()
    
    
    func setupSubviews() {
        let view = UIView.init()
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
        }
        
        logo_ImgV.clipsToBounds = true
        logo_ImgV.contentMode = .center
        view.addSubview(logo_ImgV)
        logo_ImgV.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.top.equalTo(view.snp_top)
            make.height.equalTo(170)
            make.width.equalTo(250)
        }
        
        desc_Lb.text = "暂无数据";
        desc_Lb.textColor = UIColor(hexString: "666666")
        desc_Lb.font=UIFont.systemFont(ofSize: 12)
        desc_Lb.textAlignment=NSTextAlignment.center
        view.addSubview(desc_Lb)
        desc_Lb.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(25)
            make.top.equalTo(logo_ImgV.snp_bottom)
            make.bottom.equalTo(view.snp_bottom)
        }
    }
    
    open override func awakeFromNib() {
        setupSubviews()
    }
    open override func draw(_ rect: CGRect) {
        
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    public required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


