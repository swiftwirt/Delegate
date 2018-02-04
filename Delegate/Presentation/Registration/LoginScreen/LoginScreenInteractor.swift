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
import SwiftyJSON
import FirebaseAuth
import PKHUD

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
        taps.takeUntil(output.output.rx.deallocated).flatMapLatest { [unowned self] () -> Observable<DLGUser> in
            
            guard let email = self.hasValidEmail, let password = self.hasValidPassword else { return Observable.empty() }
            
            return self.applicationManager.apiService.login(email: email, password: password).catchError { error in
                do {
                    try self.applicationManager.validationService.handle(remoteResponce: error)
                } catch {
                    AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription)
                }
                
                return Observable.empty()
            }
            
            }.flatMap { (user) -> Observable<JSON> in
                
                return self.applicationManager.apiService.fetchUser(uid: user.uid!).catchError { error in
                    do {
                        try self.applicationManager.validationService.handle(remoteResponce: error)
                    } catch {
                        AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription)
                    }
                    
                    return Observable.empty()
                }
                
            }.subscribe(onNext: { [weak self] (user) in
                
                self?.applicationManager.userService.crateNewCurrentUser(with: user)
                self?.input.routeToSelectRole()
                
            }).disposed(by: disposeBag)
    }
    
    func observeLogInFacebookTap()
    {
        output.facebookButtonObservable.flatMapLatest { [unowned self] () -> Observable<FacebookCredentials?> in
            
            let facebookService = self.applicationManager.facebookService
            facebookService.logOut()
            
            return facebookService.authWithFacebook(viewController: self.output.output).catchError { (error) in
                HUD.flash(.labeledError(title: ErrorMessage.error, subtitle: ErrorMessage.fbLoginFailed), delay:  AnimationDuration.defaultFade)
                return Observable.empty()
            }
            
            }.subscribe(onNext: { [weak self] (facebookCredentials) in
                self?.output.output.needsAnimation = false
                guard let token = facebookCredentials?.token else {
                    // here we know that FBLogin canceled and safari controller was dissmissed
                    return
                }
                let credentials = FacebookAuthProvider.credential(withAccessToken: token)
                
                Auth.auth().signIn(with: credentials) { [weak self] (user, error) in
                    
                    if let error = error {
                        AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription)
                        return
                    }
                    
                    self?.input.routeToSelectRole()
                }
                }, onError: { error in
                    AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
