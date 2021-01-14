//
//  GWContainerViewController.swift
//  GWUtilCore
//
//  Created by yangshiyu on 2020/2/13.
//

import UIKit

open class GWContainerViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    let GWContainerViewControllerCellIdentify = "GWContainerViewControllerCellIdentify"
    
    open var collectionView:UICollectionView!
    open lazy var flowLayout=UICollectionViewFlowLayout()
    
    open var viewControllers:Array<UIViewController>=[]
    
    open var selectedIndex = 0
    open var currentController:UIViewController{
        get{
            if self.viewControllers.count > self.selectedIndex {
                return self.viewControllers[self.selectedIndex]
            }else{
                return UIViewController()
            }
        }
    }
    //可能会被自定义
    open lazy var navigationView = GWContainerNavigationView {
        [weak self]
        (index) in
        let result:Bool = self?.canSelectControllerAtIndex(index: index) ?? true
        if result {
            self?.willSelectControllerAtIndex(index: index)
            self?.didSelectControllerAtIndex(index: index)
        }
        return result
    }
    
    // MARK: life cycle func
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentController.beginAppearanceTransition(true, animated: animated)
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.currentController.endAppearanceTransition()
        self.updateCollectViewSelection()
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.currentController.beginAppearanceTransition(false, animated: animated)
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.currentController.endAppearanceTransition()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if self.responds(to: #selector(setter: edgesForExtendedLayout)) {
            self.edgesForExtendedLayout = []
        }
        self.extendedLayoutIncludesOpaqueBars = false
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.flowLayout)
        self.view.addSubview(self.collectionView)
        
        //加载子页面
        self.reLoadDataSources(viewControllers: self.addChildControllers())
        
        self.setupUI()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = self.view.frame.size
        let isHidden = self.navigationController?.navigationBar.isHidden
        self.navigationView.frame=CGRect(x: 0, y: isHidden==true ? CGFloat(kDangerAreaBottomHeight) : 0, width: size.width, height: self.navigationView.customHeight)
        self.flowLayout.itemSize = CGSize(width: size.width, height: size.height-self.navigationView.frame.maxY)
        self.collectionView.frame = CGRect(x: 0, y: self.navigationView.frame.maxY, width: size.width, height: size.height-self.navigationView.frame.maxY)
    }
    // MARK: sysytem func
    open override var shouldAutomaticallyForwardAppearanceMethods: Bool{
        return false
    }
    
    // MARK: custom func
    open func setupUI() {
        self.view.addSubview(self.navigationView)
        
        self.flowLayout.scrollDirection = .horizontal
        self.flowLayout.minimumLineSpacing = 0
        self.flowLayout.minimumInteritemSpacing = 0
        
        
        self.collectionView.isPagingEnabled=true
        if #available(iOS 10.0, *) {
            self.collectionView.isPrefetchingEnabled = true
        }
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: GWContainerViewControllerCellIdentify)
        self.collectionView.delegate=self
        self.collectionView.dataSource=self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.scrollsToTop = false
        self.collectionView.backgroundColor=UIColor.white
    }
    
    open func addChildControllers() -> Array<UIViewController> {
        assert(false, "请重写addChildController函数")
        return []
    }
    
    open func reLoadDataSources(viewControllers:Array<UIViewController>) {
        if viewControllers.count == 0 {
            assert(false, "viewControllers不能为空")
            return
        }
        //清除老数据
        self.viewControllers.forEach { (vc) in
            vc.removeFromParent()
        }
        //重置viewControllers
        self.viewControllers = viewControllers
        self.viewControllers.forEach { (vc) in
            self.addChild(vc)
            
        }
        let items = self.viewControllers.map { (vc:UIViewController) -> String in
            return vc.title ?? "标题"
        }
        self.navigationView.setItems(items)
        self.navigationView.setSelectedItemIndex(0)
        
        self.collectionView.reloadData()
    }
    
    //设置当前选中项
    open func setSelectedIndex(index:Int) {
        if self.viewControllers.count>index {
            selectedIndex = index
            self.navigationView.setSelectedItemIndex(index)
            self.updateCollectViewSelection()
        }
    }
    open func willSelectControllerAtIndex(index:Int) {
        self.selectedIndex = index
        self.updateCollectViewSelection()
    }
    
    open func didSelectControllerAtIndex(index:Int) {
        
    }
    
    open func canSelectControllerAtIndex(index:Int) -> Bool {
        return true
    }
    
    open func updateCollectViewSelection() {
        let size = self.view.bounds.size
        let offsetX = size.width * CGFloat(selectedIndex)
        self.collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}


// delegate
extension GWContainerViewController {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewControllers.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GWContainerViewControllerCellIdentify, for: indexPath)
        cell.contentView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        let subView = self.viewControllers[indexPath.row].view!
        subView.frame=cell.bounds
        cell.contentView.addSubview(subView)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let vc = self.viewControllers[indexPath.row]
        vc.beginAppearanceTransition(true, animated: true)
        vc.endAppearanceTransition()
    }
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let vc = self.viewControllers[indexPath.row]
        vc.beginAppearanceTransition(false, animated: true)
        vc.endAppearanceTransition()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let size = self.view.bounds.size
        let index = Int(scrollView.contentOffset.x / size.width)
        if canSelectControllerAtIndex(index: index) {
            selectedIndex = index
        }else{
            scrollView.setContentOffset(CGPoint(x: size.width*CGFloat(selectedIndex), y: scrollView.contentOffset.y), animated: false)
        }
        self.navigationView.setSelectedItemIndex(selectedIndex)
        self.didSelectControllerAtIndex(index: selectedIndex)
    }
}


