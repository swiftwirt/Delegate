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

class DelegateTextField: SkyFloatingLabelTextFieldWithIcon {
    override var inputView: UIView? {
        didSet {
            if inputView != nil {
                shouldHaveDoneButton = true
            }
        }
    }
    
    var validationState: ValidationState = .undefined {
        didSet {
            if case .invalid(let message) = validationState {
                if let message = message {
                    errorMessage = message
                } else {
                    errorMessage = placeholder
                }
            } else {
                errorMessage = nil
            }
            
            updateColors()
        }
    }
    
    var shouldHaveDoneButton: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        configureDoneButtonIfNeeded()
        
        let superResult = super.becomeFirstResponder()
        
        if superResult {
            validationState = .undefined
        }
        
        return superResult
    }
    
    override func updateColors() {
        super.updateColors()
        
        updateImage()
    }
    
    func setup() {
        iconType = .image
        titleFormatter = { $0 }
        
        switch keyboardType {
        case .decimalPad, .numberPad, .numbersAndPunctuation, .phonePad:
            shouldHaveDoneButton = true
        default:
            break
        }
    }
    
    private func configureDoneButtonIfNeeded() {
        guard inputAccessoryView == nil && shouldHaveDoneButton else {
            return
        }
        
        let doneButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 80, y: 5, width: 70.0, height: 30.0))
        doneButton.addTarget(self, action: #selector(done(_:)), for: .touchUpInside)
        doneButton.setTitle(BetoshookStrings.next, for: .normal)
        
        let accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        accessoryView.backgroundColor = UIColor(redPart: 63, greenPart: 63, bluePart: 63)
        accessoryView.addSubview(doneButton)
        
        inputAccessoryView = accessoryView
    }
    
    private func updateImage() {
        switch validationState {
        case .undefined:
            iconImage = #imageLiteral(resourceName:"icon_unchecked")
        case .valid:
            iconImage = #imageLiteral(resourceName:"icon_checked")
        case .invalid:
            iconImage = #imageLiteral(resourceName:"icon_not_filled")
        }
    }
    
    @objc private func done(_ button: UIButton) {
        sendActions(for: .editingDidEndOnExit)
        _ = resignFirstResponder()
    }
}
