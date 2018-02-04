//
//  LoginScreenRouter.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class LoginScreenRouter {
    
    enum SegueIdentifier {
        static let toSignUp = "SegueToSignUpScreen"
        static let toSelectRole = "SegueToSelectRole"
        static let toForgotPasswordScreen = "SegueToForgotPasswordScreen"
    }
    
    weak var viewController: LoginViewController!
    
    func routeToSignUp()
    {
        perform(segueID: SegueIdentifier.toSignUp)
    }
    
    func routeToSelectRole()
    {
        perform(segueID: SegueIdentifier.toSelectRole)
    }
    
    func routeToForgotPassword()
    {
        perform(segueID: SegueIdentifier.toForgotPasswordScreen)
    }
    
    fileprivate func perform(segueID: String)
    {
        DispatchQueue.main.async { [weak self] in
            self?.viewController.animate(views: [
                self!.viewController.logoContainer,
                self!.viewController.emailInputContainer,
                self!.viewController.passwordInputContainer,
                self!.viewController.forgotPasswordContainer,
                self!.viewController.loginButtonContainer,
                self!.viewController.signupContainer,
                self!.viewController.socislPlaceholderContainer,
                self!.viewController.socialButtonsContainer
                ], ofTheScreen: true)
            Timer.after(0.5) { [weak self] in
                self?.viewController.performSegue(withIdentifier: segueID, sender: nil)
            }
        }
    }
}
