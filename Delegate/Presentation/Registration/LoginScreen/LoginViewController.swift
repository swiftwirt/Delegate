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
    
    enum SegueIdentifier {
        static let toSignUp = "SegueToSignUpScreen"
    }

    @IBOutlet weak var emailTextField: RightToLeftSensitiveTextField!
    @IBOutlet weak var passwordTextField: RightToLeftSensitiveTextField!
    
    // Login containers for animation
    
    @IBOutlet weak var emailInputContainer: UIView!
    @IBOutlet weak var passwordInputContainer: UIView!
    @IBOutlet weak var forgotPasswordContainer: UIStackView!
    
    @IBOutlet weak var loginButtonContainer: UIView!
    @IBOutlet weak var signupContainer: UIView!
    
    @IBOutlet weak var signupButton: UIButton!
    
    // Social buttons
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var googlePlusButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        observeSocialButtonsTaps()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animate(views: [emailInputContainer, passwordInputContainer, forgotPasswordContainer, loginButtonContainer, signupContainer], ofTheScreen: true)
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
    
    fileprivate func observeSocialButtonsTaps()
    {
        facebookButton.rx.tap.asObservable().takeUntil(self.rx.deallocated).flatMapLatest { [unowned self] () -> Observable<FacebookCredentials> in
            
        }
    }
    
    @IBAction func onPressedSignupButton(_ sender: Any)
    {
       performSegue(withIdentifier: SegueIdentifier.toSignUp, sender: nil)
    }
    
    @IBAction func onPressedLoginButton(_ sender: Any)
    {
        return
    }
    
}
