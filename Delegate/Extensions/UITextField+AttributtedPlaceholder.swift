//
//  UITextField+AttributtedPlaceholder.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setAttributed(placeholder: String, with color: UIColor)
    {
        let attributes = [NSAttributedStringKey.foregroundColor: color]
        self.attributedPlaceholder = NSAttributedString(string: placeholder.localized, attributes: attributes)
    }
    
}
