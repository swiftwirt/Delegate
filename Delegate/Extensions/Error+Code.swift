//
//  Error+Code.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/3/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

extension Error {
    var code: Int { return (self as NSError).code }
}
