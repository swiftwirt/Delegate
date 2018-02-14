//
//  SocialsWithFirebaseService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/5/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Firebase
import RxSwift
import TwitterKit
import SwiftyJSON

class SocialsWithFirebaseService: NSObject {
    
    func registerTwitter() -> Observable<DLGUser>
    {
        return Observable.create({ (observer) -> Disposable in
            
            let logInButton = TWTRLogInButton(logInCompletion: { session, error in
                if (session != nil) {
                    let authToken = session!.authToken
                    let authTokenSecret = session!.authTokenSecret
                    
                    let credential = TwitterAuthProvider.credential(withToken: authToken, secret: authTokenSecret)
                    
                    let twitterClient = TWTRAPIClient(userID: session!.userID)
                    twitterClient.loadUser(withID: session!.userID, completion: { (tUser, error) in
                        guard error == nil else { observer.onError(error!); return }
                        
                        Auth.auth().signIn(with: credential) { (user, error) in
                            if let error = error {
                                observer.onError(error)
                                return
                            } else {
                                let aUser = DLGUser()
                                aUser.avatarLink = tUser?.profileImageLargeURL
                                aUser.userName = tUser?.name
                                aUser.uid = Auth.auth().currentUser?.uid
                                
                                observer.onNext(aUser)
                                observer.onCompleted()
                            }
                        }
                    })
                } else {
                    observer.onError(error!)
                }
            })
            
            logInButton.sendActions(for: .touchUpInside)
            
            return Disposables.create()
        })
    }
    
    static func logOutTwitter()
    {
        let store = TWTRTwitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
    }
    
    // Linked in
    
    func registerLinkedIN() -> Observable<JSON?>
    {
        return Observable.create({ (observer) -> Disposable in
            
            LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (success) in
                
                if LISDKSessionManager.hasValidSession() {
                    let link = String(format: "https://api.linkedin.com/v1/people/~:(id,email-address,picture-url,firstName,lastName)?format=json")
                    LISDKAPIHelper.sharedInstance().getRequest(link, success: { (responce) in
                        observer.onNext(JSON(parseJSON: responce?.data ?? ""))
                    }, error: { (error) in
                        observer.onError(error!)
                    })
                }
            }, errorBlock: { (error) in
                observer.onError(error!)
            })
            
            return Disposables.create()
        })
    }
    
    static func logOutLinkedIn()
    {
        if LISDKSessionManager.hasValidSession() {
            LISDKSessionManager.clearSession()
        }
    }
}
