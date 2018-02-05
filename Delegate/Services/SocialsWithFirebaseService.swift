//
//  SocialsWithFirebaseService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/5/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import FirebaseAuth
import RxSwift
import TwitterKit

class SocialsWithFirebaseService {
    
    enum Social {
        case twitter
        case google
        case linkedIN
    }
    
    func register(with social: Social)  -> Observable<Void>
    {
        switch social {
        case .twitter:
            return registerTwitter()
        default:
            return Observable.empty()
        }
    }
    
    fileprivate func registerTwitter() -> Observable<Void>
    {
        return Observable.create({ (observer) -> Disposable in
            
            let logInButton = TWTRLogInButton(logInCompletion: { session, error in
                if (session != nil) {
                    let authToken = session!.authToken
                    let authTokenSecret = session!.authTokenSecret
                    
                    let credential = TwitterAuthProvider.credential(withToken: authToken, secret: authTokenSecret)
                    
                    Auth.auth().signIn(with: credential) { (user, error) in
                        if let error = error {
                            observer.onError(error)
                            return
                        } else {
                            observer.onNext(())
                            observer.onCompleted()
                        }
                    }
                } else {
                    observer.onError(error!)
                }
            })
            
            logInButton.sendActions(for: .touchUpInside)
            
            return Disposables.create()
        })
    }
    
}
