//
//  FirebaseService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Firebase
import RxSwift

enum FirebaseRusult<T> {
    
    case success(User)
    case failure(Error)
}

class FirebaseService {
    
    func login(email: String, password: String) -> Observable<User>
    {
        return Observable.create({ (observer) -> Disposable in
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                guard let firebaseUser = user, error == nil else {
                    // TODO: handle expected errors
                    observer.onCompleted()
                    observer.on(.error(error!))
                    return
                }
                observer.onNext(firebaseUser)
            }
            return Disposables.create()
        })
    }
    
    func signup(email: String, password: String) -> Observable<User>
    {
        return Observable.create({ (observer) -> Disposable in
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                
                guard let firebaseUser = user, error == nil else {
                    // TODO: handle expected errors
                    observer.onCompleted()
                    observer.on(.error(error!))
                    return
                }
                observer.onNext(firebaseUser)
            }
            return Disposables.create()
        })
    }
    
}
