//
//  SignUpScreenInteractor.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

class SignUpScreenInteractor {
    
    enum SegueIdentifier {
        static let toLogin = "SegueToLoginScreen"
        static let toMainScreen = "SegueToMainScreen"
    }
    
    var output: SignUpScreenPresenter!
    var input: SignUpScreenRouter!
    
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
}
