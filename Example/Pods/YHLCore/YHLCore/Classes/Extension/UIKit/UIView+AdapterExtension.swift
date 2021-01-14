//
//  UIView+AdapterExtension.swift
//  Alamofire
//
//  Created by on 2020/1/13.
//

import UIKit

//MARK: 全局适配方案设置
public struct ScreenAdapter{
    fileprivate static var adapter: ScreenAdapter = ScreenAdapter()
    fileprivate var expression: AdapterExpression = { UIScreen.main.bounds.size.width /  UIScreen.main.bounds.size.width * $0}
    public typealias AdapterExpression = (CGFloat) -> CGFloat
    public static func config(_ expr: AdapterExpression?) {
        if let ex = expr{
            Self.adapter.expression = ex
        }
    }
}

//MARK: 调用计算公式
public func adaptValue(_ value: CGFloat) -> CGFloat {
    value
//    ScreenAdapter.adapter.expression(value)
}

public func adaptRectMake(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat ) -> CGRect {
    CGRect(x: adaptValue(x), y: adaptValue(y), width: adaptValue(width), height: adaptValue(height))
}

public func adaptRectMake(_ rect: CGRect) -> CGRect {
    adaptRectMake(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
}

//MARK: Xib、UIStroyboard适配方案
public struct AdapterType: OptionSet {
    public var rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public static let constraint = AdapterType(rawValue: 1 << 1 )
    public static let fontSize = AdapterType(rawValue: 1 << 2)
    public static let cornerRadius = AdapterType(rawValue: 1 << 3)
    public static let all: AdapterType = [AdapterType.constraint, AdapterType.fontSize, AdapterType.cornerRadius]
}

public extension UIView{
    /// 对Xib、UIStroyboard适配方案, 该方案重载了几个方法.
    /// - Parameters:
    ///   - type: 是一个数组, 里面可以添加想要适配的类型. 默认ALL就行了.
    ///   - recursion: 递归遍历所有子View进行缩放
    ///   - exceptView: 哪些类型的View不想被遍历. 可以写出来, 默认nil就行
    func adapt(_ type: AdapterType, recursion: Bool = true, exceptView: [UIView]? = nil ) {
        guard !isMemeberOfExceptView(viewArray:exceptView) else {
            return
        }
        
        // 约束
        if type.contains(.constraint) {
            for subConstraint in self.constraints {
                subConstraint.constant = adaptValue(subConstraint.constant)
            }
        }
        
        if type.contains(.fontSize) {
            if let labelSelf = self as? UILabel, !labelSelf.isKind(of: NSClassFromString("UIButtonLabel")!) {
                labelSelf.font = labelSelf.font.withSize(adaptValue(labelSelf.font.pointSize))
            } else if let textFieldSelf = self as? UITextField {
                textFieldSelf.font = textFieldSelf.font!.withSize(adaptValue(textFieldSelf.font!.pointSize))
            } else if let buttonSelf = self as? UIButton {
                buttonSelf.titleLabel!.font = buttonSelf.titleLabel!.font.withSize(adaptValue(buttonSelf.titleLabel!.font.pointSize))
            } else if let textViewSelf = self as? UITextView {
                textViewSelf.font = textViewSelf.font!.withSize(adaptValue(textViewSelf.font!.pointSize))
            }
        }
        
        if type.contains(.cornerRadius), self.layer.cornerRadius != 0  {
            self.layer.cornerRadius = adaptValue(self.layer.cornerRadius)
        }
        
        if recursion {
            for subView in self.subviews {
                subView.adapt(type, recursion: recursion, exceptView: exceptView)
            }
        }
    }
    
    /// 对Xib、UIStroyboard适配方案, 该方案重载了几个方法.
    /// - Parameters:
    ///   - type: 是一个数组, 里面可以添加想要适配的类型. 默认ALL就行了.
    ///   - recursion: 递归遍历所有子View进行缩放
    ///   - exceptView: 哪些类型的View不想被遍历. 可以写出来, 默认nil就行
    func adapt(type: AdapterType, recursion: Bool = true, exceptViewClass: [UIView.Type]? = nil ) {
        guard !isMemeberOfExceptViewClass(classArray: exceptViewClass) else {
            return
        }
        
        // 约束
        if type.contains(.constraint) {
            for subConstraint in self.constraints {
                subConstraint.constant = adaptValue(subConstraint.constant)
            }
        }
        
        if type.contains(.fontSize) {
            if let labelSelf = self as? UILabel, !labelSelf.isKind(of: NSClassFromString("UIButtonLabel")!) {
                labelSelf.font = labelSelf.font.withSize(adaptValue(labelSelf.font.pointSize))
            } else if let textFieldSelf = self as? UITextField {
                textFieldSelf.font = textFieldSelf.font!.withSize(adaptValue(textFieldSelf.font!.pointSize))
            } else if let buttonSelf = self as? UIButton {
                buttonSelf.titleLabel!.font = buttonSelf.titleLabel!.font.withSize(adaptValue(buttonSelf.titleLabel!.font.pointSize))
            } else if let textViewSelf = self as? UITextView {
                textViewSelf.font = textViewSelf.font!.withSize(adaptValue(textViewSelf.font!.pointSize))
            }
        }
        
        if type.contains(.cornerRadius), self.layer.cornerRadius != 0  {
            self.layer.cornerRadius = adaptValue(self.layer.cornerRadius)
        }
        
        if recursion {
            for subView in self.subviews {
                subView.adapt(type: type, recursion: recursion, exceptViewClass: exceptViewClass)
            }
        }
    }
    
    func isMemeberOfExceptViewClass(classArray: [UIView.Type]?) -> Bool {
        if let cls = classArray {
            return cls.contains{self.isMember(of: $0)}
        }
        return false
    }
    
    func isMemeberOfExceptView(viewArray: [UIView]?) -> Bool {
        if let cls = viewArray {
            return cls.contains{self == $0}
        }
        return false
    }
}


//MARK: 手码UI适配方案
/// UIView.init(adaptFrame: CGRect(x: 40, y: 400, width: 100, height: 100)) 这样用就行.
extension UIView{//View适配
    public convenience init(adaptFrame: CGRect) {
        self.init(frame: adaptRectMake(adaptFrame))
    }
}



