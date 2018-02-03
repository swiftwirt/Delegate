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

class ApiService {
    
    fileprivate let firebaseService = FirebaseService()

    lazy var socialApiService: SocialApiService = {
        let socialApiService = SocialApiService()
        return socialApiService
    }()
    
    func login(email: String, password: String) -> Observable<User>
    {
        return firebaseService.login(email: email, password: password)
    }
    
    func signup(email: String, password: String) -> Observable<User>
    {
        return firebaseService.signup(email: email, password: password)
    }
    
    func resetPassword(for email: String) -> Observable<Void>
    {
        return firebaseService.resetPassword(for: email)
    }
    
}
