//
//  EmptyDataSetView+GWExtension.swift
//  Pods
//
//  Created by song on 2020/3/28.
//

import UIKit
import EmptyDataSet_Swift

extension EmptyDataSetView {
    
    /// 获取button
    /// - Returns: button按钮
    @discardableResult
    public func button() -> UIButton? {
        var view: UIButton?
        for content in self.subviews {
            for sub in content.subviews {
                if sub.accessibilityIdentifier == "empty set button" {
                    view = sub as? UIButton
                }
            }
        }
        return view
    }
    
    /// 获取imageView
    /// - Returns: imageView
    @discardableResult
    public func imageView() -> UIImageView? {
        var view: UIImageView?
        for content in self.subviews {
            for sub in content.subviews {
                if sub.accessibilityIdentifier == "empty set background image" {
                    view = sub as? UIImageView
                }
            }
        }
        return view
    }
    
    /// 获取titleLabel
    /// - Returns: titleLabel
    @discardableResult
    public func titleLabel() -> UILabel? {
        var view: UILabel?
        for content in self.subviews {
            for sub in content.subviews {
                if sub.accessibilityIdentifier == "empty set title" {
                    view = sub as? UILabel
                }
            }
        }
        return view
    }
    
    /// 获取detailLabel
    /// - Returns: detailLabel
    @discardableResult
    public func detailLabel() -> UILabel? {
        var view: UILabel?
        for content in self.subviews {
            for sub in content.subviews {
                if sub.accessibilityIdentifier == "empty set detail label" {
                    view = sub as? UILabel
                }
            }
        }
        return view
    }
}
