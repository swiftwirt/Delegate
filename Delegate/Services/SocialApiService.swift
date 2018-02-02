//
//  SocialApiService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import RxSwift

class SocialApiService {
    
    fileprivate let facebookService = FacebookService()
    
    // Facebook
    
    func authWithFacebook(viewController: UIViewController) -> Observable<FacebookCredentials?>
    {
        return facebookService.authWithFacebook(viewController: viewController)
    }
}
