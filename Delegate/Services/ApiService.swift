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

    lazy var socialApiService: SocialApiService = {
        let socialApiService = SocialApiService()
        return socialApiService
    }()
    
    func login(email: String, password: String) -> Observable<DLGUser>
    {
        return firebaseService.login(email: email, password: password)
    }
    
    func signup(email: String, password: String) -> Observable<DLGUser>
    {
        return firebaseService.signup(email: email, password: password)
    }
    
    func resetPassword(for email: String) -> Observable<Void>
    {
        return firebaseService.resetPassword(for: email)
    }
    
    func fetchUser(uid: String) -> Observable<JSON>
    {
        return firebaseService.fetchUser(uid: uid)
    }
    
    func update(user: DLGUser) -> Observable<Void>
    {
        return firebaseService.update(user: user)
    }
    
}
