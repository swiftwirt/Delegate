//
//  TaskCell.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/9/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var estimatedTimeLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var assigneeAuthorNameLabel: UILabel!
    @IBOutlet weak var priorityImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
