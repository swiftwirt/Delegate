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
    
    @IBOutlet weak var logoContainer: UIStackView!
    @IBOutlet weak var emailInputContainer: ValidatableView!
    @IBOutlet weak var passwordInputContainer: ValidatableView!
    @IBOutlet weak var forgotPasswordContainer: UIStackView!
    
    @IBOutlet weak var loginButtonContainer: UIView!
    @IBOutlet weak var signupContainer: UIView!
    
    @IBOutlet weak var socislPlaceholderContainer: UIView!
    @IBOutlet weak var socialButtonsContainer: UIStackView!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    // Social buttons
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var googlePlusButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    
    var output: LoginScreenInteractor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginScreenConfigurator.configure(viewController: self)
        output.configureTextFields()
        output.handleSignupTaps()
        output.handleForgotPasswordTaps()
        output.handleLoginTaps(with: emailTextField.text!, password: passwordTextField.text!)
        
        handleInputsSwitch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animate(views: [logoContainer, emailInputContainer, passwordInputContainer, forgotPasswordContainer, loginButtonContainer, signupContainer, socislPlaceholderContainer, socialButtonsContainer], ofTheScreen: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animate(views: [logoContainer, emailInputContainer, passwordInputContainer, forgotPasswordContainer, loginButtonContainer, signupContainer, socislPlaceholderContainer, socialButtonsContainer], ofTheScreen: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearAllInputs()
    }
    
    fileprivate func handleInputsSwitch()
    {
        _ = emailTextField.rx.controlEvent(.editingDidEndOnExit).takeUntil(self.rx.deallocated).asObservable().bind {
            self.switchFrom(one: self.emailTextField, to: self.passwordTextField)
        }
    }
    
    fileprivate func clearAllInputs()
    {
        emailTextField.text = nil
        passwordTextField.text = nil
    }
    
}
