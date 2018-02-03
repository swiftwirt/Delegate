//
//  SignUpScreenInteractor.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Firebase
import SwiftyJSON

class SignUpScreenInteractor {
    
    enum SegueIdentifier {
        static let toLogin = "SegueToLoginScreen"
        static let toMainScreen = "SegueToMainScreen"
    }
    
    var output: SignUpScreenPresenter!
    var input: SignUpScreenRouter!
    
    var applicationManager = ApplicationManager.instance()
    
    fileprivate let disposeBag = DisposeBag()
    
    func configureTextFields()
    {
        output.configureEmailTextField(with: Strings.email, color: Color.textFieldPlaceholder)
        output.configurePasswordTextField(with: Strings.password, color: Color.textFieldPlaceholder)
        output.configureRepeatPasswordTextField(with: Strings.repeatPassword, color: Color.textFieldPlaceholder)
    }
    
    func handleLoginTaps()
    {
        _ = output.loginButtonObservable.bind {
            self.input.goBack()
        }
    }
    
    fileprivate var hasValidEmail: String?
    {
        let email = output.currentEmailInputValue ?? ""
        
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
        let password = output.currentPasswordInputValue ?? ""
        let confirmedPassword = output.currentRepeatPasswordInputValue ?? ""
        
        do {
            
            try applicationManager.validationService.checkPasswords(password, with: confirmedPassword)
            output.addPasswordValidationError(message: nil, result: .undefined)
            output.addRepeatPasswordValidationError(message: nil, result: .undefined)
            return confirmedPassword
            
        } catch let error as PasswordValidationError {
            switch error {
            case .passwordEmpty, .passwordIncorrectFormat:
                output.addPasswordValidationError(message: error.localizedDescription, result: .invalid(errorMessage: nil))
            case .passworConfirmedEmpty, .passwordIdentity:
                output.addRepeatPasswordValidationError(message: error.localizedDescription, result: .invalid(errorMessage: nil))
            }
        } catch {
            // Should never reach to this point
            applicationManager.alertHandler.showUnknownError()
        }
        return nil
    }
    
    func handleSignUpTaps()
    {
        let taps: Observable<Void> = Observable.merge([output.signupButtonObservable, output.endOnExitRepeatPasswordInputEvent])
        taps.takeUntil(output.output.rx.deallocated).flatMapLatest { [unowned self] () -> Observable<DLGUser> in
            
            guard let email = self.hasValidEmail, let password = self.hasValidPassword else { return Observable.empty() }
            
            return self.applicationManager.apiService.signup(email: email, password: password).catchError { error in
                do {
                    try self.applicationManager.validationService.handle(remoteResponce: error)
                } catch {
                    AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription)
                }
                return Observable.empty()
            }
            
            }.flatMapLatest { (user) -> Observable<Void> in
                
                return self.applicationManager.apiService.update(user: user).catchError { error in
                    do {
                        try self.applicationManager.validationService.handle(remoteResponce: error)
                    } catch {
                        AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription)
                    }
                    return Observable.empty()
            }
        
            }.subscribe(onNext: { [weak self] (user) in
                // serialize user
                self?.input.routeToMain()
                
            }).disposed(by: disposeBag)
    }
}
