//
//  AlertHandler.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/3/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//
import UIKit
import SwiftMessages
import RxSwift

class AlertHandler: NSObject {
    
    static func showSpecialAlert(with title: String, message: String, actionTitle: String = "Ok", action: ((UIAlertAction) -> ())? = nil)
    {
        DispatchQueue.main.async {
            guard let viewController = UIApplication.shared.visibleViewController else { return }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: actionTitle, style: .cancel, handler: action)
            alertController.addAction(action)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func showSpecialActionSheet(in viewController: UIViewController, with title: String, message: String = String(), actions: [UIAlertAction])
    {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actions.forEach {
            if $0.style == .cancel {
                $0.setValue(UIColor.gray, forKey: "titleTextColor")
            }
            actionSheet.addAction($0) }
        
        actionSheet.popoverPresentationController?.sourceView = viewController.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: viewController.view.frame.size.width / 2, y: 40.0, width: 250.0, height: 300)
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    func showUnknownError()
    {
        AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: ErrorMessage.errorUnknown)
    }
    
    // Banner
    
    static func showInternetTroublesBanner()
    {
        AlertHandler.showBanner(with: ErrorMessage.troublesInternetTitle, subtitle: ErrorMessage.troublesInternetSubtitle, of: .warning)
    }
    
    static func showSlowInternetBanner()
    {
        AlertHandler.showBanner(with: ErrorMessage.slowInternetTitle, subtitle: ErrorMessage.slowInternetSubtitle, of: .warning)
    }
    
    static func showNoInternetConnectionBanner()
    {
        AlertHandler.showBanner(with: ErrorMessage.noInternetTitle, subtitle: ErrorMessage.noInternetSubtitle, of: .error)
    }
    
    static func showBanner(with title: String, subtitle: String, of type: Theme)
    {
        DispatchQueue.main.async {
            // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
            // files in the main bundle first, so you can easily copy them into your project and make changes.
            let view = MessageView.viewFromNib(layout: .messageViewIOS8)
            
            // Theme message elements with the warning style.
            view.configureTheme(type)
            
            // Add a drop shadow.
            view.configureDropShadow()
            
            view.configureContent(title: title, body: subtitle)
            view.button?.setTitle(nil, for: .normal)
            view.button?.backgroundColor = UIColor.clear
            view.iconImageView?.clipsToBounds = false
            
            var config = SwiftMessages.Config()
            
            // Slide up from the bottom.
            config.presentationStyle = .top
            
            // Display in a window at the specified window level: UIWindowLevelStatusBar
            // displays over the status bar while UIWindowLevelNormal displays under.
            config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            
            // Disable the default auto-hiding behavior.
            config.duration = .seconds(seconds: ErrorMessage.messagePresentationDuration)
            
            // Show the message.
            SwiftMessages.show(view: view)
        }
    }
}
