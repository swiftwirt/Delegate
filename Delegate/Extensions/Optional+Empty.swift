//
//  Optional+Empty.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/25/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let wrappedValue):
            return wrappedValue.isEmpty
        }
    }
}
