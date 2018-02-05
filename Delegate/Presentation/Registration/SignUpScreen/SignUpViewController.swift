//
//  SignUpViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class SignUpViewController: DelegateAbstractViewController {
    
    @IBOutlet weak var emailTextField: RightToLeftSensitiveTextField!
    @IBOutlet weak var passwordTextField: RightToLeftSensitiveTextField!
    @IBOutlet weak var repeatPasswordTextField: RightToLeftSensitiveTextField!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // Signup containers for animation
    
    @IBOutlet weak var logoContainer: UIImageView!
    @IBOutlet weak var emailInputContainer: ValidatableView!
    @IBOutlet weak var passwordInputContainer: ValidatableView!
    @IBOutlet weak var repeatPasswordContainer: ValidatableView!
    
    @IBOutlet weak var loginButtonContainer: UIView!
    @IBOutlet weak var signupContainer: UIView!
    
    @IBOutlet weak var socislPlaceholderContainer: UIView!
    @IBOutlet weak var socialButtonsContainer: UIStackView!
    @IBOutlet weak var termsOfUseContainer: UIStackView!
    // Social buttons
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var googlePlusButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    
    // Terms
    
    @IBOutlet weak var termsOfUseButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    var output: SignUpScreenInteractor!

    override func viewDidLoad() {
        super.viewDidLoad()
        SignUpScreenConfigurator.configure(viewController: self)
        output.configureTextFields()
        output.handleLoginTaps()
        output.handleSignUpTaps()
        output.observeLogInFacebookTap()
        output.observeLogInTwitterTap() 
        handleInputsSwitch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animate(views: [UIView(), logoContainer, emailInputContainer, passwordInputContainer, repeatPasswordContainer, loginButtonContainer, signupContainer, socislPlaceholderContainer, socialButtonsContainer, termsOfUseContainer], ofTheScreen: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .black
    }
    
    fileprivate func handleInputsSwitch()
    {
        _ = emailTextField.rx.controlEvent(.editingDidEndOnExit).takeUntil(self.rx.deallocated).asObservable().bind {
            self.switchFrom(one: self.emailTextField, to: self.passwordTextField)
        }
        
        _ = passwordTextField.rx.controlEvent(.editingDidEndOnExit).takeUntil(self.rx.deallocated).asObservable().bind {
            self.switchFrom(one: self.passwordTextField, to: self.repeatPasswordTextField)
        }
    }

}
