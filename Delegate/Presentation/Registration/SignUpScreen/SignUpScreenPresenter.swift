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

class SignUpScreenPresenter {
    
    weak var output: SignUpViewController!
    
    func configureEmailTextField(with text: String, color: UIColor)
    {
        output.emailTextField.setAttributed(placeholder: text, with: color)
        output.emailTextField.tintColor = color
        output.emailTextField.resignFirstResponder()
    }
    
    func configurePasswordTextField(with text: String, color: UIColor)
    {
        output.passwordTextField.setAttributed(placeholder: text, with: color)
        output.passwordTextField.tintColor = color
        output.passwordTextField.resignFirstResponder()
    }
    
    func configureRepeatPasswordTextField(with text: String, color: UIColor)
    {
        output.repeatPasswordTextField.setAttributed(placeholder: text, with: color)
        output.repeatPasswordTextField.tintColor = color
        output.repeatPasswordTextField.resignFirstResponder()
    }
    
    var currentEmailInputValue: String?
    {
        return output.emailTextField.text
    }
    
    var currentPasswordInputValue: String?
    {
        return output.passwordTextField.text
    }
    
    var currentRepeatPasswordInputValue: String?
    {
        return output.repeatPasswordTextField.text
    }
    
    var loginButtonObservable: Observable<Void>
    {
        return output.loginButton.rx.tap.asObservable().takeUntil(output.rx.deallocated)
    }
    
    var signupButtonObservable: Observable<Void>
    {
        return output.signupButton.rx.tap.asObservable().takeUntil(output.rx.deallocated)
    }
    
    var facebookButtonObservable: Observable<Void>
    {
        return output.facebookButton.rx.tap.asObservable().takeUntil(output.rx.deallocated)
    }
    
    var googleplusButtonObservable: Observable<Void>
    {
        return output.googlePlusButton.rx.tap.asObservable().takeUntil(output.rx.deallocated)
    }
    
    var linkedinButtonObservable: Observable<Void>
    {
        return output.linkedInButton.rx.tap.asObservable().takeUntil(output.rx.deallocated)
    }
    
    var twitterButtonObservable:  Observable<Void>
    {
        return output.twitterButton.rx.tap.asObservable().takeUntil(output.rx.deallocated)
    }
    
    var termsOfUseButtonObservable: Observable<Void>
    {
        return output.termsOfUseButton.rx.tap.asObservable().takeUntil(output.rx.deallocated)
    }
    
    var privacyPolicyButtonObservable:  Observable<Void>
    {
        return output.privacyPolicyButton.rx.tap.asObservable().takeUntil(output.rx.deallocated)
    }
}
