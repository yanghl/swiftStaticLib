//
//  Tools.swift
//  Mayoo
//
//  Created by wang on 2019/11/29.
//  Copyright © 2019 wang. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

public extension DefaultsKeys {
    var token :DefaultsKey<String?> {return.init("token")}
    var deviceId :DefaultsKey<String?> {return.init("deviceId")}
}
