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
}

enum StoryboardIdentifier {
    static let login = "Login"
    static let main = "Main"
}

class ApplicationRouter
{
    static func showInitialScreen()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window
        
        let storyboard = UIStoryboard(name: StoryboardIdentifier.login, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        
        if let previousView = window?.rootViewController?.view{
            UIView.transition(from: previousView, to: viewController!.view, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: { _ in
                window?.rootViewController = viewController
            })
        } else {
            window?.rootViewController = viewController
        }
    }
    
    static func showMainScreen()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window
        
        let storyboard = UIStoryboard(name: StoryboardIdentifier.main, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        
        if let previousView = window?.rootViewController?.view{
            UIView.transition(from: previousView, to: viewController!.view, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: { _ in
                window?.rootViewController = viewController
            })
        } else {
            window?.rootViewController = viewController
        }
    }
}
