//
//  TeamsTableViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/6/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TeamsTableViewController: DelegateTableViewController {
    
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var dataSource: TeamsTableViewDataSource!
    fileprivate let applicationManager = ApplicationManager.instance()
    
    fileprivate let myTeamsSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInitialSetUp()
        observeSegmentedControlValueChanged()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    @objc func refresh(_ sender: Any)
    {
        Timer.after(3.0) { [weak self] in
            self?.reloadWithAnimation(animationDirection: .down)
            self?.refreshControl?.endRefreshing()
        }
    }
    
    fileprivate func tableViewInitialSetUp()
    {
        self.currentMode = segmentedControll.selectedSegmentIndex == 0 ? .myInvites : .myTeams
        dataSource = TeamsTableViewDataSource()
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    fileprivate func observeSegmentedControlValueChanged()
    {
        segmentedControll.rx.value.asObservable().takeUntil(self.rx.deallocated).subscribe(onNext: { (value) in
            switch value {
            case self.myTeamsSelectedIndex:
                self.dataSource.mode = .myTeams
                self.currentMode = .myTeams
            default:
                self.dataSource.mode = .myInvites
                self.currentMode = .myInvites
            }
        }).disposed(by: disposeBag)
    }
    
    deinit {
        log.info("\(self) deinit")
    }

}
