//
//  DelegateTableViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/8/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import RxSwift
import AnimatableReload

enum Mode: Int {
    case undefined
    case myTeams
    case myInvites
    
    case contacts
    case contactsFacebook
    case contactsLinkedIn
    
    case delegated
    case assigned
}

class DelegateTableViewController: UITableViewController {
    
    enum AnimationDirection: String {
        case up = "up"
        case down = "down"
    }
    
    fileprivate let applicationManager = ApplicationManager.instance()
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let subject = BehaviorSubject<Mode>(value: .undefined)
    fileprivate var observableMode: Observable<Mode> {
        get {
            return subject
        }
    }
    
    var currentMode: Mode = .undefined {
        didSet {
            subject.onNext(currentMode)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeModeSwitch()
    }
    
    fileprivate func observeModeSwitch()
    {
        observableMode.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (mode) in
            guard let StrongSelf = self else { return }
            StrongSelf.reloadWithAnimation(animationDirection: .down)
            
            }, onError: { (error) in
                print(error)
        }).disposed(by: disposeBag)
    }
    
    func reloadWithAnimation(animationDirection: AnimationDirection)
    {
        AnimatableReload.reload(tableView: self.tableView, animationDirection: animationDirection.rawValue)
    }
}
