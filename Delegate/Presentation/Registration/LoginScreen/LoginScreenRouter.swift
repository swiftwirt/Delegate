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
    
    weak var viewController: UIViewController!
    
    func routeToSignUp()
    {
        viewController.performSegue(withIdentifier: SegueIdentifier.toSignUp, sender: nil)
    }
    
    func routeToSelectRole()
    {
        viewController.performSegue(withIdentifier: SegueIdentifier.toSelectRole, sender: nil)
    }
    
    func routeToForgotPassword()
    {
        viewController.performSegue(withIdentifier: SegueIdentifier.toForgotPasswordScreen, sender: nil)
    }
    
    func goBack()
    {
        viewController.returnBack()
    }
}
