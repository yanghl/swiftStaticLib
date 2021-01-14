//
//  Double+Extenstion.swift
//  GWUtilCore
//
//  Created by yangshiyu on 2020/3/22.
//

import Foundation

public extension Double {
    func toString() -> String {
        return String(format: "%.2f", self)
    }
    func toString(format:String) -> String {
        return String(format: format, self)
    }
}

