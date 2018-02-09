//
//  TeamsTableViewDataSource.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/8/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

protocol TeamsTableViewDataSourceProtocol: UITableViewDataSource, UITableViewDelegate {
    
}

class TeamsTableViewDataSource: NSObject, TeamsTableViewDataSourceProtocol {
    
    enum CellIdentifier {
        static let teamCell = "TeamCell"
        static let memberCell = "TeamMemberCell"
        static let headerCell = "HeaderCell"
    }
    
    fileprivate var myTeams = [[1,2,3],[1,2],[3]]
    fileprivate var acceptedInvitesTeams = [1,2,3,4,5]
    
    fileprivate(set) var myDealsRange: CountableClosedRange<Int>!
    
    fileprivate var invitesToTeams = [1,2,3,4]
    fileprivate var headersNumber = 2
    
    var mode: Mode = .undefined
    
    override init() {
        super.init()
        myDealsRange = 1 ... myTeams.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch mode {
        case Mode.myTeams:
            return myTeams.count + acceptedInvitesTeams.count + headersNumber
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case Mode.myTeams:
            
                switch section {
                case myDealsRange:
                    return myTeams[section - 1].count
                default:
                    return 1
                }
            
        default:
            return invitesToTeams.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch mode {
            
        case Mode.myTeams:
            return configureCellForMyTeams(indexPath: indexPath, tableView: tableView)
        default:
            return configureCellForInvites(indexPath: indexPath, tableView: tableView)
        }
    }
    
    fileprivate func getTitleMyTeams(section: Int) -> String?
    {
        switch section {
        case 0:
            return Strings.myTeams.uppercased()
        case myTeams.count + 1:
            return Strings.invited.uppercased()
        default:
            return ""
        }
    }

    // TODO: - add betopark section header title config
    
    fileprivate func configureCellForMyTeams(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
    {
        switch indexPath.section {
        case 0:
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.headerCell) as? HeaderCell
                else { fatalError() }
            headerCell.titleLabel.text = getTitleMyTeams(section: indexPath.section)
            return headerCell
        case myDealsRange:
            switch indexPath.row {
            case 0:
                guard let teamCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.teamCell) as? TeamCell
                    else { fatalError() }
                return teamCell
            default:
                guard let memberCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.memberCell) as? TeamMemberCell
                    else { fatalError() }
                return memberCell
            }
        case myTeams.count + 1:
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.headerCell) as? HeaderCell
                else { fatalError() }
            headerCell.titleLabel.text = getTitleMyTeams(section: indexPath.section)
            return headerCell
        default:
            guard let teamCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.teamCell) as? TeamCell
                else { fatalError() }
            teamCell.clipsToBounds = false
            return teamCell
        }
    }
    
    fileprivate func configureCellForInvites(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
    {
        switch indexPath.row {
        case 0:
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.headerCell) as? HeaderCell
                else { fatalError() }
            headerCell.titleLabel.text = Strings.invites.uppercased()
            return headerCell
        default:
            guard let teamCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.teamCell) as? TeamCell
                else { fatalError() }
            teamCell.clipsToBounds = false
            return teamCell
        }
    }
}

