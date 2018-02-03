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
        
        if let firstName = user.firstName {
            values[FirebaseKey.firstName] = firstName
        }
        
        if let lastName = user.lastName {
            values[FirebaseKey.lastName] = lastName
        }
        
        if let password = user.password {
            values[FirebaseKey.password] = password
        }
        
        if let birthDate = user.birthDate?.description {
            values[FirebaseKey.birthDate] = birthDate
        }
        
        if let email = user.email {
            values[FirebaseKey.email] = email
        }
        
        if let avatarLink = user.avatarLink {
            values[FirebaseKey.avatarLink] = avatarLink
        }
        
        if let uid  = user.uid  {
            values[FirebaseKey.uid ] = uid
        }

        return values
    }
}
