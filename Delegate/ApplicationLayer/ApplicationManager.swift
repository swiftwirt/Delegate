//
//  ApplicationManager.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class ApplicationManager {
    
    static func instance() -> ApplicationManager
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.applicationManager
    }
    
    let keychainService = KeychainService()
    
    lazy var thirdPartiesConfigurator: ThirdPartiesConfigurator = {
        let thirdPartiesConfigurator = ThirdPartiesConfigurator()
        return thirdPartiesConfigurator
    }()
    
    lazy var apiService: ApiService = {
        let apiService = ApiService()
        return apiService
    }()
    
    lazy var userService: UserService = {
        let service = UserService()
        return service
    }()
    
    lazy var validationService: ValidationService = {
        let service = ValidationService()
        return service
    }()
    
    lazy var alertHandler: AlertHandler = {
        let handler = AlertHandler()
        return handler
    }()
    
    lazy var reachabilityService: ReachabilityService = {
        let service = ReachabilityService()
        return service
    }()
    
    lazy var facebookService: FacebookService = {
        let service = FacebookService()
        return service
    }()
    
    lazy var socialsWithFirebaseService: SocialsWithFirebaseService = {
        let service = SocialsWithFirebaseService()
        return service
    }()
    
    lazy var supportEmailService: SupportEmailService = {
        let service = SupportEmailService()
        return service
    }()
    
    func clearKeychainIfNeeded()
    {
        guard userService.previouslyLaunched else {
            keychainService.clear()
            return
        }
    }
}
