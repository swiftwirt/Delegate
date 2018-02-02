//
//  ApplicationManager.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class ApplicationManager {
    
    static func instance() -> ApplicationManager
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.applicationManager
    }
    
    lazy var apiService: ApiService = {
        let apiService = ApiService()
        return apiService
    }()
    
}
