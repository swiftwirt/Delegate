//
//  SignUpScreenPresenter.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import GoogleSignIn

class SignUpScreenPresenter: NSObject {
    
    weak var output: SignUpViewController!
    
    fileprivate let trottlingTime = 1.0
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func configureUsernameTextField(with text: String, color: UIColor)
    {
        configure(textField: output.usernameTextField, text: text, color: color)
    }
    
    func configureEmailTextField(with text: String, color: UIColor)
    {
        configure(textField: output.emailTextField, text: text, color: color)
    }
    
    func configurePasswordTextField(with text: String, color: UIColor)
    {
        configure(textField: output.passwordTextField, text: text, color: color)
    }
    
    func configureRepeatPasswordTextField(with text: String, color: UIColor)
    {
        configure(textField: output.repeatPasswordTextField, text: text, color: color)
    }
    
    fileprivate func configure(textField: UITextField, text: String, color: UIColor)
    {
        textField.setAttributed(placeholder: text, with: color)
        textField.tintColor = color
        textField.resignFirstResponder()
    }
    
    func addUsernameValidationError(message: String?, result: ValidationState)
    {
        output.usernameInputContainer.state = result
        if let message = message {
            output.usernameTextField.insertFieldValidationMessage(message: message)
        }
    }
    
    func addEmailValidationError(message: String?, result: ValidationState)
    {
        output.emailInputContainer.state = result
        if let message = message {
            output.emailTextField.insertFieldValidationMessage(message: message)
        }
    }
    
    func addPasswordValidationError(message: String?, result: ValidationState)
    {
        output.passwordInputContainer.state = result
        if let message = message {
            output.passwordTextField.insertFieldValidationMessage(message: message)
        }
    }
    
    func addRepeatPasswordValidationError(message: String?, result: ValidationState)
    {
        output.repeatPasswordContainer.state = result
        if let message = message {
            output.repeatPasswordTextField.insertFieldValidationMessage(message: message)
        }
    }
    
    var currentUsernameValue: String?
    {
        return output.usernameTextField.text
    }
    
    var currentEmailInputValue: String?
    {
        return output.emailTextField.text
    }
    
    var currentPasswordInputValue: String?
    {
        return output.passwordTextField.text
    }
    
    var endOnExitRepeatPasswordInputEvent: Observable<Void>
    {
        return output.repeatPasswordTextField.rx.controlEvent(.editingDidEndOnExit).asObservable()
    }
    
    var currentRepeatPasswordInputValue: String?
    {
        return output.repeatPasswordTextField.text
    }
    
    var loginButtonObservable: Observable<Void>
    {
        return output.loginButton.rx.tap.asObservable().takeUntil(output.rx.deallocated).throttle(trottlingTime, scheduler: MainScheduler.instance)
    }
    
    var signupButtonObservable: Observable<Void>
    {
        return output.signupButton.rx.tap.asObservable().throttle(trottlingTime, scheduler: MainScheduler.instance)
    }
    
    var facebookButtonObservable: Observable<Void>
    {
        return output.facebookButton.rx.tap.asObservable().takeUntil(output.rx.deallocated).throttle(trottlingTime, scheduler: MainScheduler.instance)
    }
    
    var googleplusButtonObservable: Observable<Void>
    {
        return output.googlePlusButton.rx.tap.asObservable().takeUntil(output.rx.deallocated).throttle(trottlingTime, scheduler: MainScheduler.instance)
    }
    
    var linkedinButtonObservable: Observable<Void>
    {
        return output.linkedInButton.rx.tap.asObservable().takeUntil(output.rx.deallocated).throttle(trottlingTime, scheduler: MainScheduler.instance)
    }
    
    var twitterButtonObservable:  Observable<Void>
    {
        return output.twitterButton.rx.tap.asObservable().takeUntil(output.rx.deallocated).throttle(trottlingTime, scheduler: MainScheduler.instance)
    }
    
    var termsOfUseButtonObservable: Observable<Void>
    {
        return output.termsOfUseButton.rx.tap.asObservable().takeUntil(output.rx.deallocated).throttle(trottlingTime, scheduler: MainScheduler.instance)
    }
    
    var privacyPolicyButtonObservable:  Observable<Void>
    {
        return output.privacyPolicyButton.rx.tap.asObservable().takeUntil(output.rx.deallocated).throttle(trottlingTime, scheduler: MainScheduler.instance)
    }
}


extension SignUpScreenPresenter: GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.output.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.output.needsAnimation = false
        self.output.dismiss(animated: true, completion: nil)
    }
}
