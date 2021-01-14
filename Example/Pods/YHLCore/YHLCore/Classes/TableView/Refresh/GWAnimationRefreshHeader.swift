//
//  GWAnimationRefreshHeader.swift
//  GWCommonComponent
//
//  Created by yangshiyu on 2020/2/14.
//

import UIKit
import MJRefresh

open class GWAnimationRefreshHeader:MJRefreshHeader {
    var mainView:UIView
    var imageView:UIImageView
    lazy var label:UILabel = UILabel()
    var timer:Timer?
    var curTime:Int = 0
    
    

    required public init?(coder aDecoder: NSCoder) {
        mainView = UIView()
        imageView = UIImageView(image: UIImage(named: "loading"))
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        mainView = UIView()
        imageView = UIImageView(image: UIImage(named: "loading"))
        super.init(frame: frame)
    }
    
   

    override open var state: MJRefreshState{
        didSet {
            switch state {
            case .idle:
                self.imageView.stopAnimating()
                self.refreshAnimation(view: self.imageView, time: 0.5 , isDown: true)
                self.label.text = "下拉可以刷新..."
                if self.timer != nil {
                    self.stopTimer()
                }
            case .pulling:
                self.imageView.stopAnimating()
                self.refreshAnimation(view: self.imageView, time: 0.5 , isDown: false)
                self.label.text = "松开即可刷新..."
            case .refreshing:
                self.imageView.layer.removeAnimation(forKey: "animateTransform")
                self.label.text = "正在加载中..."

                self.imageView.startAnimating()

                self.startTimer()

            default:
                break
            }
        }
    }

    //初始化配置
    override open func prepare() {
        super.prepare()

        self.addSubview(self.mainView)
        self.mainView.addSubview(self.label)
        self.mainView.addSubview(self.imageView)

        setupUI()
    }

    override open func placeSubviews() {
        super.placeSubviews()

        let size = self.frame.size
        self.mainView.frame = CGRect(x: 0, y: (size.height-20)*0.5, width: size.width, height: 20)
        self.imageView.frame = CGRect(x: size.width*0.5-60, y: 0, width: 20, height: 20)
        self.label.frame = CGRect(x: size.width*0.5-30, y: 0, width: 150, height: 20)
    }
    
    func setupUI() {
        self.mainView.clipsToBounds = true;
        
        self.label.textColor = UIColor(hex: 0x666666)
        self.label.font = UIFont.systemFont(ofSize: 12)
        self.label.textAlignment = .left
        
        self.label.text = "下拉刷新"
//        var images:Array<UIImage> = []
//        var i:Int = 1
//        while i < 61  {
//            images.append(UIImage(named: "loading_"+String(i))!)
//            i+=1
//        }
//        self.imageView.animationImages = images;
//        self.imageView.animationDuration=0.5;
        
    }
    
    func refreshAnimation(view:UIView , time:Float , isDown:Bool) {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.fromValue = isDown ? (-Double.pi) : (0)
        animation.toValue = isDown ? (0) : (-Double.pi)
        animation.repeatCount = 1
        animation.duration = CFTimeInterval(time)
        animation.isRemovedOnCompletion = false
        animation.fillMode=CAMediaTimingFillMode.forwards
        
        view.layer.add(animation, forKey: "animateTransform")
        
    }
    
    func startTimer() {
        self.curTime=300
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1.5), target: self, selector: #selector(self.task(timer:)), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func task(timer:Timer) {
        self.curTime -= 1
        
        if self.curTime <= 0 {
            self.stopTimer()
        }else{
            self.imageViewAnimation()
        }
    }
    
    func imageViewAnimation() {
        
    }
}
