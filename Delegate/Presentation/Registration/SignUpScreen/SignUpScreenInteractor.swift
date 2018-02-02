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
            self.input.viewController.returnBack()
        }
    }
    
    func handleSignUpTaps()
    {
        output.signupButtonObservable.flatMapLatest { [unowned self] () -> Observable<User> in
            
            guard let email = self.output.currentEmailInputValue, let password = self.output.currentPasswordInputValue else { return Observable.empty() }
            
            return self.applicationManager.apiService.signup(email: email, password: password)
            }.catchError { error in
                // show error
                return Observable.empty()
            }.subscribe(onNext: { [weak self] (user) in
                // serialize user
                self?.input.routeToMain()
                
            }).disposed(by: disposeBag)
    }
}
