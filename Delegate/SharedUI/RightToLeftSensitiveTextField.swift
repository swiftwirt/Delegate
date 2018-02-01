//
//  File.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class RightToLeftSensitiveTextField: UITextField {
    override var inputView: UIView? {
        didSet {
            if inputView != nil {
                shouldHaveDoneButton = true
            }
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
        
        return super.becomeFirstResponder()
    }
    
    func setup() {
        handleAlignment()
        
        switch keyboardType {
        case .decimalPad, .numberPad, .numbersAndPunctuation, .phonePad:
            shouldHaveDoneButton = true
        default:
            break
        }
    }
    
    fileprivate func handleAlignment()
    {
        switch UIApplication.shared.userInterfaceLayoutDirection {
        case .rightToLeft:
            self.textAlignment = .right
        default:
            self.textAlignment = .left
        }
    }
    
    func highlightIfNeeded()
    {
        if !hasText {
            self.placeholderColor = Color.textFieldHighlighted
        }
    }
    
    private func configureDoneButtonIfNeeded() {
        guard inputAccessoryView == nil && shouldHaveDoneButton else {
            return
        }
        
        let doneButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 80, y: 5, width: 70.0, height: 30.0))
        doneButton.addTarget(self, action: #selector(done(_:)), for: .touchUpInside)
        doneButton.setTitleColor(Color.dark, for: .normal)
        // TODO: make it inspectable
        doneButton.setTitle(Strings.next, for: .normal)
        
        let accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        accessoryView.backgroundColor = Color.textFieldHighlighted
        accessoryView.addSubview(doneButton)
        
        inputAccessoryView = accessoryView
    }
    
    @objc private func done(_ button: UIButton) {
        sendActions(for: .editingDidEndOnExit)
        _ = resignFirstResponder()
    }
}
