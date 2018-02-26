//
//  DelegateTextView.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/25/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import JVFloatLabeledTextField

class DelegateTextView: JVFloatLabeledTextView {
    @IBOutlet weak var iconImageView: UIImageView?
    @IBOutlet weak var clearButton: UIButton? {
        didSet {
            if let clearButton = clearButton {
                _ = clearButton.rx.tap.takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] in
                    self?.text = nil
                    _ = self?.becomeFirstResponder()
                })
            }
        }
    }
    
    var uiControlComposition = UIControl()
    
    var validationState: ValidationState = .undefined {
        didSet {
            if case .invalid(let message) = validationState {
                placeholderTextColor = Color.textFieldHighlighted
                if let message = message {
                    if cachedPlaceholder == nil {
                        cachedPlaceholder = placeholder
                    }
                    placeholder = message
                }
            } else {
                placeholderTextColor = textColor
                if let cachedPlaceholder = cachedPlaceholder {
                    placeholder = cachedPlaceholder
                }
                cachedPlaceholder = nil
            }
            
            updateImage()
        }
    }
    
    private var cachedPlaceholder: String?
    
    override var intrinsicContentSize: CGSize {
        var superContentSize = super.intrinsicContentSize
        
        if text.isEmpty, let placeholderLabel = placeholderLabel, let floatingLabel = floatingLabel {
            superContentSize.height -= placeholderLabel.bounds.size.height - (floatingLabel.bounds.size.height + floatingLabelYPadding)
        }
        
        return superContentSize
    }
    
    override var text: String! {
        didSet {
            clearButton?.isHidden = isFirstResponder || text.isEmpty
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func becomeFirstResponder() -> Bool {
        let superResult = super.becomeFirstResponder()
        
        if superResult {
            validationState = .undefined
            alwaysShowFloatingLabel = true
            clearButton?.isHidden = true
        }
        
        return superResult
    }
    
    override func resignFirstResponder() -> Bool {
        let superResult = super.resignFirstResponder()
        
        if superResult {
            alwaysShowFloatingLabel = false
            clearButton?.isHidden = text.isEmpty
        }
        
        return superResult
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let placeholderLabel = placeholderLabel {
            placeholderLabel.frame.origin.y -= 6
            placeholderLabel.isHidden = isFirstResponder || !text.isEmpty
        }
    }
    
    private func setup() {
        switch UIApplication.shared.userInterfaceLayoutDirection {
        case .leftToRight:
            textAlignment = .left
        case .rightToLeft:
            textAlignment = .right
        }
        
        floatingLabelFont = UIFont.systemFont(ofSize: 10)
        configureInputAccessoryView()
    }
    
    fileprivate func configureInputAccessoryView()
    {
        inputAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        inputAccessoryView?.backgroundColor = UIColor(redPart: 63, greenPart: 63, bluePart: 63)
        let doneButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 80, y: 5, width: 70.0, height: 30.0))
        doneButton.addTarget(self, action: #selector(done(_:)), for: .touchUpInside)
        doneButton.setTitle(Strings.next, for: .normal)
        inputAccessoryView?.addSubview(doneButton)
    }
    
    @objc func done(_ button: UIButton)
    {
        uiControlComposition.sendActions(for: .editingDidEndOnExit)
        _ = resignFirstResponder()
    }
    
    private func updateImage() {
        switch validationState {
        case .undefined:
            iconImageView?.image = #imageLiteral(resourceName: "field_unknown")
            iconImageView?.tintColor = UIColor.gray
        case .valid:
            iconImageView?.image = #imageLiteral(resourceName: "field_valid")
            iconImageView?.tintColor = Color.green
        case .invalid:
            iconImageView?.image = #imageLiteral(resourceName: "field_invalid")
            iconImageView?.tintColor = Color.textFieldHighlighted
        }
    }
}
