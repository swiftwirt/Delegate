//
//  TasksTableViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/6/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TasksTableViewController: DelegateTableViewController {
    
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var dataSource: TasksDataSource!
    fileprivate let applicationManager = ApplicationManager.instance()
    
    fileprivate let delegatedByUserTasks = 0
    
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
        self.currentMode = segmentedControll.selectedSegmentIndex == 0 ? .delegated : .assigned
        dataSource = TasksDataSource()
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
            switch value {
            case self.delegatedByUserTasks:
                self.dataSource.mode = .delegated
                self.currentMode = .delegated
            default:
                self.dataSource.mode = .assigned
                self.currentMode = .assigned
            }
        }).disposed(by: disposeBag)
    }
    
    deinit {
        log.info("\(self) deinit")
    }
}

