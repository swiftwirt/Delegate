//
//  LoginScreenConfigurator.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

class LoginScreenConfigurator {
    
    static func configure(viewController: LoginViewController)
    {
        let interactor = LoginScreenInteractor()
        viewController.output = interactor
        
        let presenter = LoginScreenPresenter()
        interactor.output = presenter
        
        let router = LoginScreenRouter()
        router.viewController = viewController
        interactor.input = router
        
        presenter.output = viewController   
    }
}
