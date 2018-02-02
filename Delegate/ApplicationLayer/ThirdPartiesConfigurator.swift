//
//  ThirdPartiesConfigurator.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Firebase

class ThirdPartiesConfigurator {
    
    func configure()
    {
        configureFirebase()
    }
    
    fileprivate func configureFirebase()
    {
        FirebaseApp.configure()
    }
}
