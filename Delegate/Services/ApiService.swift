//
//  ApiService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import SwiftyJSON

class ApiService {
    
    fileprivate let firebaseService = FirebaseService()
    fileprivate let facebookService = FacebookService()
    
    func login(email: String, password: String) -> Observable<DLGUser>
    {
        return firebaseService.login(email: email, password: password)
    }
    
    func signup(email: String, password: String) -> Observable<Void>
    {
        return firebaseService.signup(email: email, password: password)
    }
    
    func updatePassword(_ password: String)
    {
        firebaseService.updatePassword(password)
    }
    
    func updateEmail(_ email: String)
    {
        firebaseService.updateEmail(email)
    }
    
    func resetPassword(for email: String) -> Observable<Void>
    {
        return firebaseService.resetPassword(for: email)
    }
    
    func updateSettings(settings: Settings?)
    {
        firebaseService.updateSettings(settings: settings)
    }
    
    func fetchUser(uid: String) -> Observable<JSON>
    {
        return firebaseService.fetchUser(uid: uid)
    }
    
    func fetchUserSettings(uid: String) -> Observable<JSON>
    {
        return firebaseService.fetchUserSettings(uid: uid)
    }
    
    func update(user: DLGUser) -> Observable<Void>
    {
        return firebaseService.update(user: user)
    }
    
    func updateUser(property: FirebaseKey, value: Any?) -> Observable<Void>
    {
        return firebaseService.updateUser(property: property, value: value)
    }
    
    func saveAdded(avatar: UIImage) -> Observable<String>
    {
        return firebaseService.saveAdded(avatar: avatar)
    }
    
    func updateTeam(_ team: Team) -> Observable<String>
    {
        return firebaseService.updateTeam(team)
    }
    
    // Facebook
    
    func authWithFacebook(viewController: UIViewController) -> Observable<(FacebookCredentials?, String?)>
    {
        return facebookService.authWithFacebook(viewController: viewController)
    }
    
    func fetchFBFriends() -> Observable<JSON>
    {
        return facebookService.fetchFriends()
    }
    
}
