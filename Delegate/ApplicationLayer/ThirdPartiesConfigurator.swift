//
//  ThirdPartiesConfigurator.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Firebase
import TwitterKit
import GoogleSignIn

class ThirdPartiesConfigurator {
    
    func configure()
    {
        configureFirebase()
        configureTwitter()
        configureGoogle()
    }
    
    fileprivate func configureFirebase()
    {
        FirebaseApp.configure()
    }
    
    fileprivate func configureTwitter()
    {
        TWTRTwitter.sharedInstance().start(withConsumerKey: "bLgnQ08xC61pMqNAl0vwNeooo", consumerSecret: "OUuatb3zVdOsZay5YTb2gwz1EYj2mdFBIqto1JCCxAmx0D6wVQ")
    }
    
    fileprivate func configureGoogle()
    {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    }
}
