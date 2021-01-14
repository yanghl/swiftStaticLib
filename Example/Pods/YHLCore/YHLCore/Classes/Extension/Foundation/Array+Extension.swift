//
//  Array+Extension.swift
//  Pods
//
//  Created by song on 2020/4/1.
//

import UIKit

extension Array {
    
    /// SwifterSwift: JSON String from dictionary.
    ///
    ///        arr.jsonString() -> "[1,2,3,4,5]"
    ///
    ///        arr.jsonString(prettify: false)
    ///        /*
    ///        returns the following string:
    ///        "[\"1\",\"2\",\"3\"]"
    ///        */
    ///
    /// - Parameter prettify: set true to prettify string (default is false).
    /// - Returns: optional JSON String (if applicable).
    public func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }

}
