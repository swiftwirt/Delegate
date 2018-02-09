//
//  TasksDataSource.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/9/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

protocol TasksDataSourceProtocol: UITableViewDataSource, UITableViewDelegate {
    
}

class TasksDataSource: NSObject, TeamsTableViewDataSourceProtocol {
    
    enum CellIdentifier {
        static let taskCell = "TaskCell"
        static let taskCutCell = "TaskCutCell"
        static let teamCell = "TeamCell"
        static let memberCell = "TeamMemberCell"
        static let headerCell = "HeaderCell"
    }
    
    fileprivate var assignedToUserTasks = [[1,2,3],[1,2]]
    fileprivate var delegatedByUserTasks = [[1,2,3],[1,2],[1,2,3,4,5]]
    
    var mode: Mode = .undefined
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch mode {
        case .delegated:
            return delegatedByUserTasks.count
        default:
            return assignedToUserTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = section - 1 > 0 ? section - 1 : section
        switch mode {
        case .delegated:
            return delegatedByUserTasks[index].count
        default:
            return assignedToUserTasks[index].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch mode {
            
        case .delegated:
            return configureCellForDelegatedByUserTask(indexPath: indexPath, tableView: tableView)
        default:
            return configureCellForAssignedToUserTasks(indexPath: indexPath, tableView: tableView)
        }
    }
    
    fileprivate func getTitleForDelegatedByUserTaskTeams(section: Int) -> String?
    {
        let index = section - 1 > 0 ? section - 1 : section
        return String(delegatedByUserTasks[index].count)
    }
    
    fileprivate func getTitleForAssignedByUserTaskTeams(section: Int) -> String?
    {
        let index = section - 1 > 0 ? section - 1 : section
        return String(assignedToUserTasks[index].count)
    }
    
    // TODO: - add betopark section header title config
    
    fileprivate func configureCellForDelegatedByUserTask(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
    {
        switch indexPath.row {
        case 0:
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.headerCell) as? HeaderCell
                else { fatalError() }
            headerCell.titleLabel.text = getTitleForDelegatedByUserTaskTeams(section: indexPath.section)
            return headerCell
        case 1:
            guard let taskCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.taskCell) as? TaskCell
                else { fatalError() }
            taskCell.clipsToBounds = false
            return taskCell
        default:
            guard let memberCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.memberCell) as? TeamMemberCell
                else { fatalError() }
            memberCell.clipsToBounds = false
            return memberCell
        }
    }
    
    fileprivate func configureCellForAssignedToUserTasks(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
    {
        switch indexPath.row {
        case 0:
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.headerCell) as? HeaderCell
                else { fatalError() }
            headerCell.titleLabel.text = getTitleForAssignedByUserTaskTeams(section: indexPath.section)
            return headerCell
        case 1:
            guard let teamCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.teamCell) as? TeamCell
                else { fatalError() }
            teamCell.clipsToBounds = false
            return teamCell
        default:
            guard let taskCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.taskCutCell) as? TaskCutCell
                else { fatalError() }
            taskCell.clipsToBounds = false
            return taskCell
        }
        
    }
}
