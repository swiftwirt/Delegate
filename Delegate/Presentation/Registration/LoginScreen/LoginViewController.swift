//
//  LoginViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class LoginViewController: DelegateAbstractViewController {

    @IBOutlet weak var emailTextField: RightToLeftSensitiveTextField!
    
    @IBOutlet weak var passwordTextField: RightToLeftSensitiveTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
    }
    
    fileprivate func configureTextFields()
    {
        emailTextField.setAttributed(placeholder: Strings.email, with: Color.textFieldPlaceholder)
        emailTextField.tintColor = Color.textFieldPlaceholder
        emailTextField.resignFirstResponder()
        
        passwordTextField.setAttributed(placeholder: Strings.password, with: Color.textFieldPlaceholder)
        passwordTextField.tintColor = Color.textFieldPlaceholder
        passwordTextField.resignFirstResponder()
    }

}
