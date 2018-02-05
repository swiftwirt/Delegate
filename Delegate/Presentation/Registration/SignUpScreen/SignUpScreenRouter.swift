//
//  SignUpScreenRouter.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class SignUpScreenRouter {
    
    enum SegueIdentifier {
        static let toSignUp = "SegueToSignUpScreen"
        static let toPresentation = "SegueToPresentation"
    }
    
    weak var viewController: SignUpViewController!
    
    func routeToPresentation()
    {
        DispatchQueue.main.async { [weak self] in
            self?.viewController.animate(views: [UIView(), self!.viewController.logoContainer, self!.viewController.emailInputContainer, self!.viewController.passwordInputContainer, self!.viewController.repeatPasswordContainer, self!.viewController.loginButtonContainer, self!.viewController.signupContainer, self!.viewController.socislPlaceholderContainer, self!.viewController.socialButtonsContainer, self!.viewController.termsOfUseContainer], ofTheScreen: true)
            Timer.after(0.5) { [weak self] in
                self?.viewController.performSegue(withIdentifier: SegueIdentifier.toPresentation, sender: nil)
            }
        }
    }
    
    func goBack()
    {
        DispatchQueue.main.async { [weak self] in
            self?.viewController.animate(views: [UIView(), self!.viewController.logoContainer, self!.viewController.emailInputContainer, self!.viewController.passwordInputContainer, self!.viewController.repeatPasswordContainer, self!.viewController.loginButtonContainer, self!.viewController.signupContainer, self!.viewController.socislPlaceholderContainer, self!.viewController.socialButtonsContainer, self!.viewController.termsOfUseContainer], ofTheScreen: true)
            Timer.after(0.5) { [weak self] in
                self?.viewController.returnBack()
            }
        }
    }
}
