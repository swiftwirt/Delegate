//
//  SignUpScreenRouter.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class SignUpScreenRouter {
    
    typealias Action = () -> ()
    
    weak var viewController: SignUpViewController!
    
    fileprivate let waitingInterval: Double = 0.5
    
    func routeToPresentation()
    {
        perform(routerActiion: ApplicationRouter.showPresentationScreen, waitingTimeInterval: waitingInterval)
    }
    
    func routeToLogin()
    {
        perform(routerActiion: ApplicationRouter.showLoginScreen, waitingTimeInterval: waitingInterval)
    }
    
    fileprivate func perform(routerActiion: @escaping Action, waitingTimeInterval: Double)
    {
        DispatchQueue.main.async { [weak self] in
            self?.viewController.animate(views: [ UIView(),
                self!.viewController.logoContainer,
                self!.viewController.usernameInputContainer,
                self!.viewController.emailInputContainer,
                self!.viewController.passwordInputContainer,
                self!.viewController.repeatPasswordContainer,
                self!.viewController.loginButtonContainer,
                self!.viewController.signupContainer,
                self!.viewController.socislPlaceholderContainer,
                self!.viewController.socialButtonsContainer,
                self!.viewController.termsOfUseContainer
                ],
                ofTheScreen: true)
        }

        Timer.after(waitingTimeInterval) {
            routerActiion()
        }
    }
}
