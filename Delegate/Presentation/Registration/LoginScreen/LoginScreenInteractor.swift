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
    
    func handleLoginTaps(with email: String, password: String)
    {
        let taps: Observable<Void> = Observable.merge([output.loginButtonObservable, output.endOnExitPasswordInputEvent])
        taps.takeUntil(output.output.rx.deallocated).flatMapLatest { [unowned self] () -> Observable<User> in
            
            guard let email = self.output.currentEmailInputValue, let password = self.output.currentPasswordInputValue else { return Observable.empty() }
            
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
