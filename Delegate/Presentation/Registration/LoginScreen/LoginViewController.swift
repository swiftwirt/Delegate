//
//  LoginViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: DelegateAbstractViewController {

    @IBOutlet weak var emailTextField: RightToLeftSensitiveTextField!
    @IBOutlet weak var passwordTextField: RightToLeftSensitiveTextField!
    
    // Login containers for animation
    
    @IBOutlet weak var emailInputContainer: UIView!
    @IBOutlet weak var passwordInputContainer: UIView!
    @IBOutlet weak var forgotPasswordContainer: UIStackView!
    
    @IBOutlet weak var loginButtonContainer: UIView!
    @IBOutlet weak var signupContainer: UIView!
    
    @IBOutlet weak var socialPlaceholderContainer: UIView!
    @IBOutlet weak var socialButtonsContainer: UIStackView!
    
    @IBOutlet weak var signupButton: UIButton!
    
    // Signup containers for animation
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var isOnScreen: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isOnScreen = true
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
    
    @IBAction func onPressedSignupButton(_ sender: Any)
    {
        isOnScreen = !isOnScreen
        animate(views: [emailInputContainer, passwordInputContainer, forgotPasswordContainer, loginButtonContainer, signupContainer, socialPlaceholderContainer, socialButtonsContainer], ofTheScreen: isOnScreen)
    }
    
}
