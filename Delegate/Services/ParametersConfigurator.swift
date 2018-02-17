//
//  ParametersConfigurator.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/3/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

struct ParametersConfigurator {
    
    static func userUpdateParameters(_ user: DLGUser) -> [String: Any]
    {
        var values = [String: Any]()

        values[FirebaseKey.naviteUser.rawValue] = user.naviteUser
        
        if let userName = user.userName {
            values[FirebaseKey.userName.rawValue] = userName
        }
        
        if let firstName = user.firstName {
            values[FirebaseKey.firstName.rawValue] = firstName
        }
        
        if let lastName = user.lastName {
            values[FirebaseKey.lastName.rawValue] = lastName
        }
        
        if let password = user.password {
            values[FirebaseKey.password.rawValue] = password
        }
        
        if let birthDate = user.birthDate?.description {
            values[FirebaseKey.birthDate.rawValue] = birthDate
        }
        
        if let email = user.email {
            values[FirebaseKey.email.rawValue] = email
        }
        
        if let avatarLink = user.avatarLink {
            values[FirebaseKey.avatarLink.rawValue] = avatarLink
        }
        
        if let uid  = user.uid  {
            values[FirebaseKey.uid.rawValue] = uid
        }

        return values
    }
}
