//
//  ForgotPasswordViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ForgotPasswordViewController: DelegateAbstractViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var logoContainer: UIStackView!
    @IBOutlet weak var emailInputContainer: ValidatableView!
    @IBOutlet weak var resetButtonContainer: UIView!
    @IBOutlet weak var backButtonContainer: UIView!
    
    fileprivate let waitingTime = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlaceholders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animate(views: [logoContainer, emailInputContainer, resetButtonContainer, backButtonContainer], ofTheScreen: false)
    }
    
    fileprivate func configurePlaceholders()
    {
        emailTextField.becomeFirstResponder()
        emailTextField.setAttributed(placeholder: Strings.email, with: Color.textFieldPlaceholder)
    }

    @IBAction func onPressedBackButton(_ sender: Any) {
        view.endEditing(true)
        animate(views: [logoContainer, emailInputContainer, resetButtonContainer, backButtonContainer], ofTheScreen: true)
        Timer.after(waitingTime) {
            self.returnBack()
        }
    }
    
}
