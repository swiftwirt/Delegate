//
//  FriendsDataSource.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/9/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

protocol FriendsDataSourceProtocol: UITableViewDataSource, UITableViewDelegate {
    
}

class FriendsDataSource: NSObject, FriendsDataSourceProtocol {
    
    enum CellIdentifier {
        static let contactCell = "ContactCell"
    }
    
    var mode: Mode = .undefined
    
    fileprivate let applicationManager = ApplicationManager.instance()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case .contacts:
            return applicationManager.userService.contacts.count
        case .contactsFacebook:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch mode {
        case .contacts:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.contactCell, for: indexPath) as! ContactCell
            cell.contact = applicationManager.userService.contacts[indexPath.row]
            return cell
        case .contactsFacebook:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.contactCell, for: indexPath) as! ContactCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.contactCell, for: indexPath) as! ContactCell
            return cell
        }
    }
}
