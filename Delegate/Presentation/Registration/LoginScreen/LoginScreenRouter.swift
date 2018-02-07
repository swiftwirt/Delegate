//
//  LoginScreenRouter.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class LoginScreenRouter {
    
    typealias Action = () -> ()
    
    weak var viewController: LoginViewController!
    
    func routeToSignUp()
    {
        perform(routerActiion: ApplicationRouter.showSignupScreen)
    }
    
    func routeToSelectRole()
    {
        perform(routerActiion: ApplicationRouter.showSelectRoleScreen)
    }
    
    func routeToForgotPassword()
    {
        perform(routerActiion: ApplicationRouter.showForgotPasswordScreen)
    }
    
    fileprivate func perform(routerActiion: @escaping Action)
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
        }
        Timer.after(0.5) {
            routerActiion()
        }
    }
}
