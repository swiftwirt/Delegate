//
//  SignUpScreenRouter.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

class SignUpScreenRouter {
    
    enum SegueIdentifier {
        static let toSignUp = "SegueToSignUpScreen"
        static let toMainScreen = "SegueToMainScreen"
    }
    
    weak var viewController: SignUpViewController!
    
    func routeToSignUp()
    {
        viewController.performSegue(withIdentifier: SegueIdentifier.toSignUp, sender: nil)
    }
    
    func routeToMain()
    {
        viewController.performSegue(withIdentifier: SegueIdentifier.toMainScreen, sender: nil)
    }
    
    func goBack()
    {
        viewController.returnBack()
    }
}
