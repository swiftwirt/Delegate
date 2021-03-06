//
//  SignUpScreenConfigurator.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

class SignUpScreenConfigurator {
    
    static func configure(viewController: SignUpViewController)
    {
        let interactor = SignUpScreenInteractor()
        viewController.output = interactor
        
        let presenter = SignUpScreenPresenter()
        interactor.output = presenter
        
        let router = SignUpScreenRouter()
        router.viewController = viewController
        interactor.input = router
        
        presenter.output = viewController
    }
}
