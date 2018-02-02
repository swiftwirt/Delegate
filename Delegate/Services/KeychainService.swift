//
//  KeychainService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import KeychainSwift

class KeychainService
{
    // To remove value set it to nil
    private enum Consts {
        
        static let tokenPush = "tokenPush"
        static let fbToken = "fbToken"
        
    }
    
    fileprivate let keychain = KeychainSwift()
    
    var tokenPush: String? {
        get {
            return keychain.get(Consts.tokenPush)
        }
        set {
            if let token = newValue {
                keychain.set(token, forKey: Consts.tokenPush)
            } else {
                // Check if deletes and remove this comment or use keychain.delete in clear()
                keychain.delete(Consts.tokenPush)
            }
        }
    }
    
    var fbToken: String? {
        get {
            return keychain.get(Consts.fbToken)
        }
        set {
            if let token = newValue {
                keychain.set(token, forKey: Consts.fbToken)
            } else {
                // Check if deletes and remove this comment or use keychain.delete in clear()
                keychain.delete(Consts.fbToken)
            }
        }
    }
    
    func clear()
    {
        tokenPush = nil
        fbToken = nil
    }
}
