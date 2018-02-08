//
//  TeamCell.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/8/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var membersNumberLabel: UILabel!
    
    @IBOutlet weak var joinButton: UIButton!
     @IBOutlet weak var leaveButton: UIButton!
     @IBOutlet weak var dismissButton: UIButton!
    
    var model: Team! {
        didSet {
            configureOutlets(model: model)
        }
    }
    
    func configureOutlets(model: Team)
    {
        
    }
}
