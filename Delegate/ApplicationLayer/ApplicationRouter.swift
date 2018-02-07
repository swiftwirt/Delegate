//
//  ApplicationRouter.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/3/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

enum ViewControllerIdentifier {
    static let loginViewController = "LoginViewController"
    static let mainViewController = "MainViewController"
    static let signUpViewController = "SignUpViewController"
}

enum StoryboardIdentifier {
    static let login = "Login"
    static let main = "Main"
    static let signUp = "SignUp"
    static let password = "ForgotPassword"
    static let presentation = "Intro"
    static let selectRole = "SelectRole"
    
}

class ApplicationRouter
{
    
    static func instance() -> ApplicationRouter
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.applicationRouter
    }
    
    static func showLoginScreen()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window
        
        let storyboard = UIStoryboard(name: StoryboardIdentifier.login, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()

        window?.rootViewController = viewController
    }
    
    static func showSignupScreen()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window
        
        let storyboard = UIStoryboard(name: StoryboardIdentifier.signUp, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        
        window?.rootViewController = viewController
    }
    
    static func showForgotPasswordScreen()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window
        
        let storyboard = UIStoryboard(name: StoryboardIdentifier.password, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        
        window?.rootViewController = viewController
    }
    
    static func showPresentationScreen()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        guard let window = appDelegate.window, let rootViewController = window.rootViewController else {
            return
        }
        
        let storyboard = UIStoryboard(name: StoryboardIdentifier.presentation, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        
        viewController?.view.frame = rootViewController.view.frame
        viewController?.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            window.rootViewController = viewController
        }, completion: nil)
    }
    
    static func showSelectRoleScreen()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window
        
        let storyboard = UIStoryboard(name: StoryboardIdentifier.selectRole, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        
        window?.rootViewController = viewController
    }
    
    static func showMainScreen()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        guard let window = appDelegate.window, let rootViewController = window.rootViewController else {
            return
        }
        
        let storyboard = UIStoryboard(name: StoryboardIdentifier.main, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()

        viewController?.view.frame = rootViewController.view.frame
        viewController?.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.8, options: .transitionCrossDissolve, animations: {
            window.rootViewController = viewController
        }, completion: nil)
    }
}
