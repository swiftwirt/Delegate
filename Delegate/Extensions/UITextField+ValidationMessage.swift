//
//  UITextField+ValidationMessage.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/3/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

extension UITextField {
    
    func insertFieldValidationMessage(message: String, highlightColor: UIColor = .white)
    {
        self.becomeFirstResponder()
        self.text = ""
        self.attributedPlaceholder = NSAttributedString(string: message.localized, attributes: [NSAttributedStringKey.foregroundColor: highlightColor])
        self.tintColor = highlightColor
    }
    
}
