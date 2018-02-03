//
//  LoginScreenInteractor.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Firebase

class LoginScreenInteractor {
    
    var output: LoginScreenPresenter!
    var input: LoginScreenRouter!
    var applicationManager = ApplicationManager.instance()
    
    fileprivate let disposeBag = DisposeBag()
    
    func configureTextFields()
    {
        output.configureEmailTextField(with: Strings.email, color: Color.textFieldPlaceholder)
        output.configurePasswordTextField(with: Strings.password, color: Color.textFieldPlaceholder)
    }
    
    func handleForgotPasswordTaps()
    {
        _ = output.forgotPasswordButtonObservable.bind {
            self.input.routeToForgotPassword()
        }
    }
    
    func handleSignupTaps()
    {
        _ = output.signupButtonObservable.bind {
            self.input.routeToSignUp()
        }
    }
    
    fileprivate var hasValidEmail: String?
    {
        let email = self.output.currentEmailInputValue ?? ""
        
        do {
            try applicationManager.validationService.validate(email: email)
            output.addEmailValidationError(message: nil, result: .undefined)
            return email
        } catch {
            output.addEmailValidationError(message: error.localizedDescription, result: .invalid(errorMessage: nil))
        }
        // nil is used to detect that current input is not a valid email
        return nil
    }
    
    fileprivate var hasValidPassword: String?
    {
        let password = self.output.currentPasswordInputValue ?? ""
        
        do {
            try applicationManager.validationService.validate(password: password)
            output.addPasswordValidationError(message: nil, result: .undefined)
            return password
        } catch {
            output.addPasswordValidationError(message: error.localizedDescription, result: .invalid(errorMessage: nil))
        }
        // nil is used to detect that current input is not a valid email
        return nil
    }
    
    func handleLoginTaps(with email: String, password: String)
    {
        let taps: Observable<Void> = Observable.merge([output.loginButtonObservable, output.endOnExitPasswordInputEvent])
        taps.takeUntil(output.output.rx.deallocated).flatMapLatest { [unowned self] () -> Observable<User> in
            
            guard let email = self.hasValidEmail, let password = self.hasValidPassword else { return Observable.empty() }
            
            return self.applicationManager.apiService.login(email: email, password: password)
            }.catchError { error in
                // show error
                return Observable.empty()
            }.subscribe(onNext: { [weak self] (user) in
                // serialize user
                self?.input.routeToMain()
                
            }).disposed(by: disposeBag)
    }
}
