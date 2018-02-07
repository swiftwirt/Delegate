//
//  MainViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    fileprivate let arrayOfImageNameForSelectedState = [
        #imageLiteral(resourceName: "gang2"),
        #imageLiteral(resourceName: "buddies"),
        #imageLiteral(resourceName: "chores"),
        #imageLiteral(resourceName: "histories"),
        #imageLiteral(resourceName: "settings")
    ]
    
    fileprivate let arrayOfImageNameForUnselectedState = [
        #imageLiteral(resourceName: "gang2"),
        #imageLiteral(resourceName: "buddies"),
        #imageLiteral(resourceName: "chores"),
        #imageLiteral(resourceName: "histories"),
        #imageLiteral(resourceName: "settings")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBar()
    }
    
    fileprivate func setUpBar()
    {
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageForSelectedState   = arrayOfImageNameForSelectedState[i]
                let imageForUnselectedState = arrayOfImageNameForUnselectedState[i]
                
                self.tabBar.items?[i].selectedImage = imageForSelectedState.withRenderingMode(.alwaysTemplate)
                self.tabBar.items?[i].image = imageForUnselectedState.withRenderingMode(.alwaysTemplate)
            }
        }
        
        let selectedColor   = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        let unselectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)
    }
}
