//
//  SettingsScreenInteractor.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/13/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import RxSwift
import RxCocoa

class SettingsScreenInteractor: NSObject {
    
    enum SwitcherIndexes: Int {
        case adsSwitcher = 0
        case congratulationsSwitcher = 1
        case localNotificationsSwitcher = 2
        case pushSwitcher = 3
    }
    
    var output: SettingsScreenPresenter!
    var input: SettingsScreenRouter!
    
    fileprivate let userService = ApplicationManager.instance().userService
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    
    func setAvatar()
    {
        output.setAvatar(link: userService.user?.avatarLink)
    }
    
    func initialSetup()
    {
        output.initialSetup(native: userService.user?.naviteUser ?? false, userName: userService.user?.userName ?? ErrorMessage.noUsername, email: userService.email, settings: userService.user?.settings)
    }
    
    func setupSwitchers()
    {
        let switchersChain = output.witchersChain
        
        for (index, switcher) in switchersChain.enumerated() {
            switcher.rx.value.asObservable().takeUntil(self.output.output.rx.deallocated).subscribe(onNext: { (bool) in
                switch index {
                case SwitcherIndexes.adsSwitcher.rawValue:
                    self.userService.user?.settings?.needsAds = bool
                case SwitcherIndexes.congratulationsSwitcher.rawValue:
                    self.userService.user?.settings?.congratulations = bool
                case SwitcherIndexes.localNotificationsSwitcher.rawValue:
                    self.userService.user?.settings?.localNotifications = bool
                default:
                    self.userService.user?.settings?.push = bool
                }
            }).disposed(by: disposeBag)
        }
    }
    
    func logOut()
    {
        ApplicationManager.instance().clearAllUserData()
    }
    
}
