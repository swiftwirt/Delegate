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
    
    enum SegueIdentifier {
        static let toSignUp = "SegueToSignUpScreen"
        static let toMainScreen = "SegueToMainScreen"
    }
    
    var output: LoginScreenPresenter!
    var input: LoginScreenRouter!
    var applicationManager = ApplicationManager.instance()
    
    fileprivate let disposeBag = DisposeBag()
    
    func configureTextFields()
    {
        output.configureEmailTextField(with: Strings.email, color: Color.textFieldPlaceholder)
        output.configurePasswordTextField(with: Strings.password, color: Color.textFieldPlaceholder)
    }
    
    func handleSignupTaps()
    {
        _ = output.signupButtonObservable.bind {
            self.input.viewController.performSegue(withIdentifier: SegueIdentifier.toSignUp, sender: nil)
        }
    }
    
    func handleLoginTaps(with email: String, password: String)
    {
        output.loginButtonObservable.flatMapLatest { [unowned self] () -> Observable<User> in
            return self.applicationManager.apiService.login(email: email, password: password)
            }.catchError { error in
                // show error
                return Observable.empty()
            }.subscribe(onNext: { [weak self] (user) in
                // serialize user
                self?.input.viewController.performSegue(withIdentifier: SegueIdentifier.toMainScreen, sender: nil)
            }).disposed(by: disposeBag)
    }
}
