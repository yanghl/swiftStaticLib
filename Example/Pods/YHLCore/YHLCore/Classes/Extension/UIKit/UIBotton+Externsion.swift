//
//  Botton+Externsion.swift
//  ShopApp
//
//  Created by eme on 16/8/17.
//  Copyright © 2016年 eme. All rights reserved.
//

import UIKit
import Kingfisher
extension UIButton {
    /**
     改变button 的imageview 和 title为垂直排列
     
     - parameter offset:
     */
    public func changeEdgeVertical(_ offset:Float) {
        let titleSize = self.titleLabel!.intrinsicContentSize
        let imageSize = self.imageView!.bounds.size
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -imageSize.height - CGFloat(offset / 2), right: 0.0)
        self.imageEdgeInsets = UIEdgeInsets(top: -titleSize.height - CGFloat(offset / 2), left: 0.0, bottom: 0.0, right: -titleSize.width)
    }
    /**
     改变button 的imageview 在title的左侧
     
     - parameter offset:
     */
    public func changeEdgeLeftImage(_ offset:CGFloat) {
        let titleSize = self.titleLabel!.intrinsicContentSize
        let imageSize = self.imageView!.bounds.size
        self.imageEdgeInsets = UIEdgeInsets(top: 0,left: titleSize.width + offset, bottom: 0, right: -(titleSize.width + offset));
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageSize.width + offset), bottom: 0, right: imageSize.width + offset)
        
    }
    /// 同意修改按钮配置颜色
    public func changeBackgroundImage(_ defaultColor:UIColor,highlightedColor:UIColor ,disabledColor:UIColor ) {
        self.setBackgroundImage(UIImage(color: defaultColor, size: CGSize(width: 1, height: 1)), for: .normal)
        self.setBackgroundImage(UIImage(color: highlightedColor, size: CGSize(width: 1, height: 1)), for: .highlighted)
        self.setBackgroundImage(UIImage(color: disabledColor, size: CGSize(width: 1, height: 1)), for: .disabled)
    }
}
extension UIButton {
    /// 通过key 加载网络图片
    public func setUrlImage(url:String , forState state: UIControl.State = .normal , options:KingfisherOptionsInfo = [.transition(ImageTransition.fade(1.2))]) -> Void {
        self.kf.setImage(with: URL(string: url)! , for: state,options:options)
    }
}

//图文布局
extension UIButton {
    //不论按钮有多宽 文字在按钮的最左边 图片在最右边
    public func resetLayout() {
        guard  let image = self.currentImage else {
            return
        }
        
        let frame = self.titleLabel!.frame;
        
        let titleX = (self.frame.size.width - frame.size.width + image.size.width)*0.5;
        let imageX = (self.frame.size.width - image.size.width + frame.size.width)*0.5;
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0,left: -titleX, bottom: 0,right: titleX)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageX, bottom: 0, right: -imageX);
        
    }
    
    //文字和按钮仅仅调换位置 但还是居中展示
    public func resetLayout2() {
        guard  let image = self.currentImage else {
            return
        }
        self.titleEdgeInsets = UIEdgeInsets(top: 0,left: -image.size.width, bottom: 0,right: image.size.width)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.titleLabel!.frame.width, bottom: 0, right: -self.titleLabel!.frame.width);
        
    }
    
    public func resetLayout3() {
        guard  let image = self.currentImage else {
            return
        }
        
        let frame = self.titleLabel!.frame;
        
        let imageX = (self.frame.size.width - image.size.width + frame.width)*0.5;
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0,left: -image.size.width-10, bottom: 0,right: image.size.width+10)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageX, bottom: 0, right: -imageX);
    }
    
    public func verticalLayout() {
        
        let imageW = self.imageView?.frame.width
        let imageH = self.imageView?.frame.height
        
        let titleW = self.titleLabel?.frame.width
        let titleH = self.titleLabel?.frame.height
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0,left: -imageW!, bottom: -imageH!-13,right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: -titleH!, left: 0, bottom: 0, right: -titleW!);
        
    }
}
