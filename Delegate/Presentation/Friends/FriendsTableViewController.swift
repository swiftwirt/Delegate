//
//  FriendsTableViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/6/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FriendsTableViewController: DelegateTableViewController {
    
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var dataSource: FriendsDataSource!
    fileprivate let applicationManager = ApplicationManager.instance()
    
    fileprivate let myContactsSelectedIndex = 0
    fileprivate let fbContactsSelectedIndex = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInitialSetUp()
        observeSegmentedControlValueChanged()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    @objc func refresh(_ sender: Any)
    {
        refreshControl?.beginRefreshing()
        Timer.after(3.0) { [weak self] in
            self?.reloadWithAnimation(animationDirection: .down)
            self?.refreshControl?.endRefreshing()
        }
    }
    
    fileprivate func tableViewInitialSetUp()
    {
        self.currentMode = getCurrentMode(segmentedControlValue: segmentedControll.selectedSegmentIndex)
        dataSource = FriendsDataSource()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    fileprivate func observeSegmentedControlValueChanged()
    {
        segmentedControll.rx.value.asObservable().takeUntil(self.rx.deallocated).subscribe(onNext: { (value) in
            self.dataSource.mode = self.getCurrentMode(segmentedControlValue: value)
            self.currentMode = self.getCurrentMode(segmentedControlValue: value)
        }).disposed(by: disposeBag)
    }
    
    fileprivate func getCurrentMode(segmentedControlValue: Int) -> Mode
    {
        switch segmentedControlValue {
        case myContactsSelectedIndex:
            return .contacts
        case fbContactsSelectedIndex:
            return .contactsFacebook
        default:
            return .contactsLinkedIn
        }
    }
    
    deinit {
        log.info("\(self) deinit")
    }
}
