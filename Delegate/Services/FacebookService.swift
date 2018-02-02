//
//  FacebookService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import RxSwift

struct FacebookCredentials {
    var token: String
    var email: String
}

class FacebookService {
    
    private enum FacebookPermission {
        static let email = "email"
        static let publicProfile = "public_profile"
        static let userFriends = "user_friends"
    }
    
    fileprivate let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
    
    fileprivate var shareButton: FBSDKShareButton!
    
    func authWithFacebook(viewController: UIViewController) -> Observable<FacebookCredentials?>
    {
        return Observable.create({ (observer) -> Disposable in
            
            self.fbLoginManager.logIn(withReadPermissions: [FacebookPermission.email, FacebookPermission.publicProfile, FacebookPermission.userFriends], from: viewController) { (result, error) in
                if let error = error {
                    observer.onCompleted()
                    observer.on(.error(error))
                } else {
                    let fbLoginResult : FBSDKLoginManagerLoginResult = result!
                    
                    if (fbLoginResult.isCancelled) {
                        observer.on(.next(nil))
                        observer.on(.completed)
                    } else if (fbLoginResult.grantedPermissions.contains(FacebookPermission.email)) {
                        if let token = FBSDKAccessToken.current().tokenString {
                            
                            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email"]).start(completionHandler: { (connection, result, error) -> Void in
                                
                                guard error == nil else {
                                    
                                    observer.on(.next(nil))
                                    observer.on(.completed)
                                    return
                                }
                                
                                if let dictionary = result as? [String: Any], let email = dictionary[JSONKey.email] as? String {
                                    
                                    let facebookCredentials = FacebookCredentials(token: token, email: email)
                                    
                                    observer.on(.next(facebookCredentials))
                                    observer.on(.completed)
                                } else {
                                    observer.on(.next(nil))
                                    observer.on(.completed)
                                }
                                
                            })
                            
                        } else {
                            observer.on(.next(nil))
                            observer.on(.completed)
                        }
                    }
                }
            }
            return Disposables.create()
        })
    }
    
    // https://developers.facebook.com/docs/sharing/reference/feed-dialog/v2.6#params
    func share(link: String)
    {
        let content = FBSDKShareLinkContent()
        content.contentURL = URL(string: link)
        
        shareButton = FBSDKShareButton()
        shareButton.shareContent = content
        shareButton.sendActions(for: .touchUpInside)
    }
    
    func logOut()
    {
        fbLoginManager.logOut()
    }
}

