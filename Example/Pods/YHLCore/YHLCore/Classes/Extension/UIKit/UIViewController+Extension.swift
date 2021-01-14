//
//  UIViewControllerExtension.swift
//  GWUtilCore
//
//  Created by wang on 2019/12/25.
//

import Foundation

private var keyString: Void?

public extension UIViewController {
    static var sbDic:[String:UIStoryboard] = [:]
    static  let kVCTitle = "vctitle"
    static  let kVCMessage = "vcmessage"
    static  let kVCUrl = "vcurl"

    
    /// 传值的参数
    var params:[String:Any]? {
        set {
            objc_setAssociatedObject(self, &keyString, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return (objc_getAssociatedObject(self, &keyString) as? [String : Any])
        }
    }
    
    
    /// 通过SstoryBoard获取VC
    /// - Parameters:
    ///   - Class: 获取VC的类名
    ///   - storyBoardName: 获取的VC所在的storyBoard的name
    func instanceViewControler(Class:AnyClass,storyBoardName:String?) -> UIViewController? {
        getVC(Class: Class, storyBoardName: storyBoardName, title: nil, params: nil)
    }
    
    /// 通过SstoryBoard获取VC 并传递参数
    /// - Parameters:
    ///   - Class: 获取VC的类名
    ///   - storyBoardName: 获取的VC所在的storyBoard的name
    ///   - title: 设置VC的title
    ///   - params: 给VC传递参数
    func getVC(Class:AnyClass,storyBoardName:String?,title:String?,params:[String:Any]?) -> UIViewController? {
        var vc:UIViewController
              if let sbName = storyBoardName {
                  var sb:UIStoryboard
                  if UIViewController.sbDic[sbName] != nil {
                      sb = UIViewController.sbDic[sbName]!
                      // GWLog("缓存字典中取出storyBoard:\(sbName).storyBoard")
                  }else{
                      guard let ClassType = Class as? UIViewController.Type else {
                         // GWLog("初始化 Class:\(Class)失败")
                         return nil
                         }
                     let pb = Bundle(for: ClassType.classForCoder())
                      sb = UIStoryboard(name: sbName, bundle: pb)
                      // GWLog("缓存字典中没有storyBoard:\(sbName).storyBoard ,需要自己创建")
                      UIViewController.sbDic[sbName] = sb
                  }

                guard let classIdentifier = NSStringFromClass(Class).components(separatedBy: ".").last else {
                    // GWLog("获取classIdentifier:\(Class)失败")
                    return nil
                }
                vc = sb.instantiateViewController(withIdentifier: classIdentifier)
                 }else{
                     guard let ClassType = Class as? UIViewController.Type else {
                      // GWLog("初始化 Class:\(Class)失败")
                      return nil
                  }
                     vc = ClassType.init()
                 }
        if let ti = title {
            vc.title = ti
        }
        vc.params = params
        return vc
    }
    
    /// 页面push跳转
    /// - Parameter vc: 要push到的VC
    func pushTo(vc:UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /// 页面push跳转并传参数
    /// - Parameters:
    ///   - Class: 要push到的VC的类名
    ///   - storyBoardName: VC所在的storyBoard的name
    ///   - params: 传递给Vc的参数
    func pushTo(Class:AnyClass,storyBoardName:String?,params:[String:Any]?) {
        var vc:UIViewController
        if let sbName = storyBoardName {
            var sb:UIStoryboard
            if UIViewController.sbDic[sbName] != nil {
                sb = UIViewController.sbDic[sbName]!
                // GWLog("缓存字典中取出storyBoard:\(sbName).storyBoard")
            }else{
                guard let ClassType = Class as? UIViewController.Type else {
                   // GWLog("初始化 Class:\(Class)失败")
                   return
                   }
                let pb = Bundle(for: ClassType.classForCoder())
                sb = UIStoryboard(name: sbName, bundle: pb)
                
//                GWLog("缓存字典中没有storyBoard:\(sbName).storyBoard ,需要自己创建")
                UIViewController.sbDic[sbName] = sb
            }
           guard let classIdentifier = NSStringFromClass(Class).components(separatedBy: ".").last else {
//                GWLog("获取classIdentifier:\(Class)失败")
                return
            }
            vc = sb.instantiateViewController(withIdentifier: classIdentifier)
           }else{
               guard let ClassType = Class as? UIViewController.Type else {
//                GWLog("初始化 Class:\(Class)失败")
                return
            }
               vc = ClassType.init()
           }
        if let param = params {
            if let title:String = param[UIViewController.kVCTitle] as? String {
                vc.title = title
            }
        }
        vc.params = params
           navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 返回上页
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    /// 返回上两页
    func popDouble() {
        pop(num: 2)
    }
    
    /// 返回前几页
    /// - Parameter num: 返回的页数
    func pop(num:Int) {
        let array = navigationController?.viewControllers
        if array?.count == 0 { return }
        var vc:UIViewController?
        
        if array?.count ?? 0 > num {
            vc = array?[array!.count - num - 1]
        }else{
            vc = array?[0]
        }
        guard let popToVC = vc else {
            return
        }
        navigationController?.popToViewController(popToVC , animated: true)
    }
    
}
