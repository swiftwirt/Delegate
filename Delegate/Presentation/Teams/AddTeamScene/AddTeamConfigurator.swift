//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

class AddTeamConfigurator {
    
    static func configure(_ viewController: AddTeamViewController)
    {
        let presenter = AddTeamPresenter()
        presenter.output = viewController

        let interactor = AddTeamInteractor()
        interactor.output = presenter

        viewController.output = interactor
    }
}
