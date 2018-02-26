//
//  DelegateTextField.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/21/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class DelegateFloatingLabelTextField: DelegateTextField {
    override func updateColors() {
        super.updateColors()
        
        if isEditing {
            placeholderColor = UIColor.clear
        } else if hasErrorMessage {
            placeholderColor = errorColor
        } else if let textColor = textColor {
            placeholderColor = textColor
        }
    }
    
    override func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let horizontalInset = iconWidth + iconMarginLeft
        var rect = super.titleLabelRectForBounds(bounds, editing: editing)
        rect.size.width -= horizontalInset
        
        if isLTRLanguage {
            rect.origin.x += horizontalInset
        }
        
        return rect
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.placeholderRect(forBounds: bounds)
        rect.origin.y = (bounds.size.height - textHeight()) / 2
        rect.size.height = textHeight()
        return rect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return editingRect(forBounds: bounds)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.frame.origin.y = (bounds.size.height - textHeight()) / 2
    }
    
    override func isTitleVisible() -> Bool {
        return isEditing || hasText
    }
    
    override func setup() {
        super.setup()
        
        titleFont = UIFont.systemFont(ofSize: 10)
    }
}

