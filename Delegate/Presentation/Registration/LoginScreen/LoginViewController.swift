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
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
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
        output.handleLoginTaps(with: emailTextField.text!, password: passwordTextField.text!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animate(views: [emailInputContainer, passwordInputContainer, forgotPasswordContainer, loginButtonContainer, signupContainer], ofTheScreen: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animate(views: [emailInputContainer, passwordInputContainer, forgotPasswordContainer, loginButtonContainer, signupContainer], ofTheScreen: false)
    }
    
}
