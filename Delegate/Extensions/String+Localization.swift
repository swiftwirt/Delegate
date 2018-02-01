//
//  String+Localization.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(withComment: String) -> String
    {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
}
