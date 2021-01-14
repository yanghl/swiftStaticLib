//
//  GWContainerNavigationView.swift
//  GWUtilCore
//
//  Created by yangshiyu on 2020/2/13.
//

import UIKit
import SwifterSwift

public enum GWNavigatorViewAligment:Int {
    case Left = 0
    case Center
}
open class GWContainerNavigationView: UIView {

// MARK: 公共方法
    ///导航条高度
    open var customHeight:CGFloat = 44.0
    ///导航条元素
    open var items:Array<String> = []
    ///普通状态字体颜色
    open var normalTextColor = UIColor.gray{
        didSet{
            self.buttons.forEach { (btn) in
                btn.setTitleColor(self.normalTextColor, for: .normal)
            }
        }
    }
    ///选中状态字体颜色
    open var selectedTextColor = UIColor.black {
        didSet{
            self.buttons.forEach { (btn) in
                btn.setTitleColor(self.selectedTextColor, for: .selected)
                btn.setTitleColor(self.selectedTextColor, for: .highlighted)
            }
        }
    }
    ///普通状态字体
    open var normalTextFont = UIFont.systemFont(ofSize: 12) {
        didSet{
            self.buttons.forEach { (btn) in
                if btn != self.selectedBtn {
                    btn.titleLabel?.font = self.normalTextFont
                }
            }
            self.resetButtonFrame()
            self.setNeedsLayout()
        }
    }
    ///普通状态背景色
    open var normalBackgroundColor = UIColor.clear {
        didSet{
            self.buttons.forEach { (btn) in
                if btn != self.selectedBtn {
                    btn.backgroundColor = self.normalBackgroundColor
                }
            }
            self.resetButtonFrame()
            self.setNeedsLayout()
        }
    }
    
    ///选中状态字体
    open var selectedTextFont = UIFont.systemFont(ofSize: 14){
        didSet{
            self.selectedBtn.titleLabel?.font = self.selectedTextFont
            self.resetButtonFrame()
            self.setNeedsLayout()
        }
    }
    ///选中状态背景色
    open var selectedBackgroundColor = UIColor.clear{
        didSet{
            self.selectedBtn.backgroundColor = self.selectedBackgroundColor
            self.resetButtonFrame()
            self.setNeedsLayout()
        }
    }
    
    ///底部线条颜色
    open var bottomColor = UIColor.blue {
        didSet{
            self.selectLayer.backgroundColor = bottomColor.cgColor
        }
    }
    ///底部线条大小
    open var borderSize = CGSize(width: 30, height: 2) {
        didSet{
            self.selectLayer.frame = CGRect(origin: self.selectLayer.frame.origin, size:borderSize )
        }
    }
    ///button 圆角
    open var cornerRadiusCount:CGFloat = 0.0 {
        didSet{
            self.buttons.forEach { (btn) in
                btn.layer.cornerRadius = self.cornerRadiusCount
            }
            self.resetButtonFrame()
            self.setNeedsLayout()
        }
    }
    ///两个元素左右间距
    open var margin:CGFloat = 8
    open var buttonHeight:CGFloat = 28
    open var aligment:GWNavigatorViewAligment = .Center //只有当总宽度小于容器宽度才有效
   
    // MARK: 私有属性
    //如果需要selectedIndex值。请调用GWContainerViewController的selectedIndex属性
    private var selectedIndex = 0
    private var scrollView:UIScrollView = {
        var scroll = UIScrollView()
        scroll.scrollsToTop=false
        scroll.bounces=true
        scroll.showsVerticalScrollIndicator=false
        scroll.showsHorizontalScrollIndicator=false
        scroll.contentInset=UIEdgeInsets.zero
        scroll.backgroundColor=UIColor.clear
        return scroll
    }()
    public var selectLayer:CALayer = {
        var layer = CALayer ()
        layer.backgroundColor = UIColor.blue.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: 30, height: 2)
        return layer
    }()
    
    private var buttonFrames:Array<CGFloat>=[]
    private var selectedBtn:UIButton!
    private var buttons:Array<UIButton> = []
    
    var block:((_ selectedIndex:Int) -> Bool)!
    convenience init(block:@escaping ((_ selectedIndex:Int) -> Bool)) {
        self.init()
        self.addSubview(self.scrollView)
        self.scrollView.layer.addSublayer(self.selectLayer)
        self.selectLayer.backgroundColor=self.bottomColor.cgColor
        self.block=block
    }
    
    func resetButtonFrame() {
        self.buttonFrames=[]//清空
        self.items.forEach { (title) in
            let key = title as NSString
            let frame = key.boundingRect(with: CGSize(width: 0, height: 30), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font:self.selectedTextFont], context: nil)
            self.buttonFrames.append(frame.size.width)
        }
    }
    
    func setItems(_ items:Array<String>) {
        self.items = items
        self.buttons.forEach { (btn) in
            btn.removeFromSuperview()
        }
        self.buttons=[]//清空
        self.items.forEach { (title) in
            let btn = UIButton()
            btn.setTitle(title, for: .normal)
            btn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
            btn.setTitleColor(self.normalTextColor, for: .normal)
            btn.setTitleColor(self.selectedTextColor, for: .selected)
            btn.setTitleColor(self.selectedTextColor, for: .highlighted)
            btn.backgroundColor = self.normalBackgroundColor
            btn.titleLabel?.font = self.normalTextFont
            btn.titleLabel?.textAlignment = .center
            btn.clipsToBounds = true
            btn.tag=self.buttons.count//刚好一一对应
            self.scrollView.addSubview(btn)
            self.buttons.append(btn)
        }
        //设置默认选项
        self.selectedBtn=self.buttons.first
        self.selectedBtn.isSelected = true
        self.selectedBtn.titleLabel?.font = self.selectedTextFont
        self.selectedBtn.backgroundColor = self.selectedBackgroundColor
        //更新frame
        self.resetButtonFrame()
        //重新布局
        self.setNeedsLayout()
    }
    
    func setSelectedItemIndex(_ index:Int,isAnimation:Bool = true) {
       
        if selectedIndex == index {
            return
        }
        self.selectedIndex=index
        self.selectedBtn.isSelected = false
        if isAnimation == true {
            self.scaleAnimation(layer: self.selectedBtn.layer, from: 1.2, to: 1.0, duration: 0.35, remove: false, repeats: 1)
        }
        self.selectedBtn.titleLabel?.font = self.normalTextFont
        self.selectedBtn.backgroundColor = self.normalBackgroundColor
        self.selectedBtn = self.buttons[index]
        self.selectedBtn.isSelected = true
        self.selectedBtn.titleLabel?.font = self.selectedTextFont
        self.selectedBtn.backgroundColor = self.selectedBackgroundColor
        if isAnimation == true {
            self.scaleAnimation(layer: self.selectedBtn.layer, from: 0.8, to: 1.0, duration: 0.35, remove: false, repeats: 1)
        }
        self.updateOffset(btn: self.selectedBtn)
    }
    
    func setSelectedItemIndex(_ index:Int) {
        setSelectedItemIndex(index, isAnimation: true)
    }
    
    @objc func btnClick(sender:UIButton) {
        if self.selectedBtn == sender {
            return
        }
        let result =  block(sender.tag)
        if result {
            self.setSelectedItemIndex(sender.tag)
        }
    }
    
    //设置选中的button居中
    func updateOffset(btn:UIButton) {
        let offsetX:CGFloat = btn.center.x+self.frame.origin.x - self.center.x;
        var point:CGPoint
        //scrollView.contentSize.width < self.bounds.size.width 内容不满一屏
        if (offsetX < 0 || scrollView.contentSize.width < self.bounds.size.width){
            point = CGPoint(x: 0, y: 0)
        }else if (offsetX > (scrollView.contentSize.width - self.bounds.size.width)){
            point = CGPoint(x:scrollView.contentSize.width - self.bounds.size.width , y: 0)
        }else{
            point = CGPoint(x: offsetX, y: 0)
        }
        
        UIView.animate(withDuration: 0.35) {
            self.scrollView.contentOffset=point
        }
        self.selectLayer.position = CGPoint(x: self.selectedBtn.center.x, y: self.frame.size.height-self.selectLayer.frame.size.height+1)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.scrollView.frame=self.bounds
        
        let sum = self.buttonFrames.reduce(0) { $0 + $1 }
        if self.aligment == .Left || sum>self.frame.size.width {
            var x:CGFloat = margin*0.5 , height = self.frame.size.height
            for (index,item) in self.buttons.enumerated() {
                item.frame=CGRect(x: x, y: 0, width: self.buttonFrames[index]+margin, height: buttonHeight)
                x=item.frame.maxX
            }
            self.scrollView.contentSize=CGSize(width: x, height: height)
        }else{
            let contentCount = CGFloat(self.buttonFrames.count)
            let contentWidth:CGFloat = self.frame.size.width-margin*(contentCount+1.0)
            var x:CGFloat = margin, width = contentWidth/contentCount
            for (_,item) in self.buttons.enumerated() {
                item.frame=CGRect(x: x, y: 0, width: width, height: buttonHeight)
                x=item.frame.maxX+margin
                
            }
            self.scrollView.contentSize=self.frame.size
        }
        
        self.selectLayer.position = CGPoint(x: self.selectedBtn.center.x, y: self.frame.size.height-self.selectLayer.frame.size.height+1)
        
    }
    
     func scaleAnimation (layer:CALayer,from:CGFloat,to:CGFloat,duration:Float,remove:Bool,repeats:Float) {
        let scaleA = CABasicAnimation.init(keyPath: "transform.scale")
        scaleA.fromValue = from
        scaleA.toValue = to
        scaleA.duration = CFTimeInterval(duration)
        scaleA.repeatCount = repeats
        scaleA.isRemovedOnCompletion = remove
        layer.add(scaleA, forKey: "transform_scale")
    }
}



