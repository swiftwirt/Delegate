//
//  SignUpViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: RightToLeftSensitiveTextField!
    @IBOutlet weak var passwordTextField: RightToLeftSensitiveTextField!
    @IBOutlet weak var repeatPasswordTextField: RightToLeftSensitiveTextField!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
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
    }

}
