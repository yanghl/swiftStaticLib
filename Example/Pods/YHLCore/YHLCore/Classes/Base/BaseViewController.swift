//
//  BaseViewController.swift
//  Pods
//
//  Created by song on 2020/3/4.
//

import UIKit
import RxCocoa
import RxSwift
import URLNavigator

public protocol CommonInitProtocol {
    init(navigator: YHLNavigatorType & NavigatorType, param:[String:Any]?)
    init(navigator: YHLNavigatorType & NavigatorType)
}

open class BaseViewController: UIViewController,CommonInitProtocol {
    open lazy var emptyView = EmptyDataView()
    open lazy var errorView = ErrorPageView()
    public let disposeBag = DisposeBag()
    public var navigator: YHLNavigator?
    
    /// 纯代码, 不需要使用context初始化方式
    required public init(navigator: YHLNavigatorType & NavigatorType) {
        self.navigator = navigator as? YHLNavigator
        super.init(nibName: nil, bundle: nil)
    }
    
    /// 纯代码, 需要使用context初始化方式
    required public init(navigator: YHLNavigatorType & NavigatorType, param:[String:Any]?){
        super.init(nibName: nil, bundle: nil)
        self.title = param?["title"] as? String
        self.params = param
        self.navigator = navigator as? YHLNavigator
    }
    
    /// storyboard 初始化
    required public init?(coder: NSCoder) {
        self.navigator = YHLNavigator.shared
        super.init(coder: coder)
    }
    
    /// xib 初始化 携带参数
    convenience public init(bundle nibBundleOrNil: Bundle?, param:[String:Any]?) {
        self.init(nibName: nil, bundle: nibBundleOrNil)
        self.title = param?["title"] as? String
        self.params = param
    }
    
    /// xib 初始化
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.navigator = YHLNavigator.shared
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if self.responds(to: #selector(setter: edgesForExtendedLayout)) {
            self.edgesForExtendedLayout = []
        }
        self.extendedLayoutIncludesOpaqueBars = false
        
        self.setupUI()
        /// 界面主题设置
        self.setViewTheme()
        /// 绑定到viewmodel 设置
        self.bindToViewModel()
    }
    
    /// 自定义leftBarButtonItem
    open func customLeftBarButtonItem()  {
        guard let url = Bundle(for: BaseViewController.self).url(forResource: "GWUtilCore", withExtension: "bundle") else { return }
        let image = UIImage(named: "nav_back", in: Bundle(url: url), compatibleWith: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backToView))
    }
    
    /// 自定义返回上级界面
    @objc open func backToView()  {
        self.navigationController?.popViewController(animated: true)
    }
    
    //子类重写该方法 进行页面布局 一定要记得super
    open func setupUI() {
        
    }
    
    /// app 主题 设置
    open func setViewTheme() {
        
    }
    
    /// 绑定到viewmodel 设置
    open func bindToViewModel() {
        
    }
    
    open func showEmptyView() {
        self.hiddenErrorView()
        view.insertSubview(emptyView, at: 0)
        emptyView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    open func showEmptyView(_ image:UIImage,title:String) {
        emptyView.desc_Lb.text = title
        emptyView.logo_ImgV.image = image
        self.showEmptyView()
    }
    
    open func hiddenEmptyView() {
        emptyView.removeFromSuperview()
    }
    
    open func showErrorView() {
        self.hiddenEmptyView()
        view.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    open func hiddenErrorView() {
        errorView.removeFromSuperview()
    }
    
}
