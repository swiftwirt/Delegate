//
//  AppDelegate.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let applicationManager = ApplicationManager()
    fileprivate let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        applicationManager.clearKeychainIfNeeded()
        
        applicationManager.thirdPartiesConfigurator.configure()
        applicationManager.reachabilityService.configureReachability()
        observeInternetConnection()
        handleUserRestoration()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        applicationManager.userService.saveUser()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        applicationManager.userService.saveUser()
    }
    
    fileprivate func handleUserRestoration()
    {
        if applicationManager.userService.needsRestoration {
            applicationManager.userService.loadUser()
            ApplicationRouter.showMainScreen()
        } else {
            ApplicationRouter.showInitialScreen()
        }
    }
    
    fileprivate func observeInternetConnection()
    {
        applicationManager.reachabilityService.observableReachabilityStatus.subscribe(onNext: { (mode) in
            
            switch mode {
            case .reachableViaWifi, .reachableViaCell3G, .reachableViaCell4G:
                print("Reachable now with good speed :-)")
            case .reachableViaCell2G:
                print("Reachable now with slow speed :-)")
                AlertHandler.showSlowInternetBanner()
            case .notReachable:
                print("Now not reachable :-(")
                AlertHandler.showNoInternetConnectionBanner()
            }
            
        }, onError: { (error) in
            print(error)
        }).disposed(by: disposeBag)
    }


}

