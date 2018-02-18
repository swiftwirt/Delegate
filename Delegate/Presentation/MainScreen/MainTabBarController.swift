//
//  MainViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import RxSwift

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    fileprivate let arrayOfImageNameForSelectedState = [
        #imageLiteral(resourceName: "gang2"),
        #imageLiteral(resourceName: "buddies"),
        #imageLiteral(resourceName: "chores"),
        #imageLiteral(resourceName: "histories"),
        #imageLiteral(resourceName: "settings")
    ]
    
    fileprivate let arrayOfImageNameForUnselectedState = [
        #imageLiteral(resourceName: "gang_grey"),
        #imageLiteral(resourceName: "buddies_grey"),
        #imageLiteral(resourceName: "chores_grey"),
        #imageLiteral(resourceName: "histories_grey"),
        #imageLiteral(resourceName: "settings_grey")
    ]
    
    fileprivate let applicationManager = ApplicationManager.instance()
    fileprivate let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBar()
        self.delegate = self
        fetchSettings()
    }
    
    fileprivate func fetchSettings()
    {
        if let uid = applicationManager.userService.user?.uid {
            applicationManager.apiService.fetchUserSettings(uid: uid).subscribe(onNext: { [weak self] (json) in
                self?.applicationManager.userService.user?.settings = Settings(json: json) ?? Settings()
            }).disposed(by: disposeBag)
        }
    }
    
    func switchToTab(_ index:Int, dismissingModals: Bool) -> UIViewController?
    {
        var rootViewController: UIViewController? = nil
        
            self.selectedIndex = index
            // make sure we pop to root
            if let navigationController = self.viewControllers?[index] as? UINavigationController {
                if let presentedViewController = navigationController.topViewController?.presentedViewController , dismissingModals == true {
                    presentedViewController.dismiss(animated: false, completion: nil)
                }
                
                navigationController.popToRootViewController(animated: false)
                rootViewController = navigationController.viewControllers.first
            }
        return rootViewController
    }

    
    fileprivate func setUpBar()
    {
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageForSelectedState   = arrayOfImageNameForSelectedState[i]
                let imageForUnselectedState = arrayOfImageNameForUnselectedState[i]
                
                self.tabBar.items?[i].selectedImage = imageForSelectedState.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = imageForUnselectedState.withRenderingMode(.alwaysOriginal)
            }
        }

        let selectedColor = UIColor(redPart: 0, greenPart: 158, bluePart: 131)
        let unselectedColor = UIColor.lightGray

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)
    }
    
    
    //Used by to GymViewController to know which tab tapped.
    var barItemTitle: String?
    var currentViewController: UIViewController?
    
    deinit {
        log.info("\(self) deinit")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        log.info("Going to tab: \(item.title ?? "(nil)")")
        barItemTitle = item.title
    }
    
    func popAllViewControllers()
    {
        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                // Most tabs are simple
                if let navigationController = viewController as? UINavigationController {
                    navigationController.popToRootViewController(animated: false)
                }
            }
        }
    }
    
    func whatTabAmIRootOn(_ myViewController: UIViewController) -> Int?
    {
        if let viewControllers = self.viewControllers {
            for i in 0..<viewControllers.count {
                let viewController = viewControllers[i]
                
                if myViewController == viewController {
                    return i
                } else if let navigationController = viewController as? UINavigationController,
                    let topViewController = navigationController.topViewController , myViewController == topViewController {
                    return i
                }
            }
        }
        return nil // myViewController was not found on root
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if currentViewController != viewController {
            log.info("Seleted view controller \(viewController)");
            popAllViewControllers()
        } else {

        }
        
        currentViewController = viewController
        
    }
}
