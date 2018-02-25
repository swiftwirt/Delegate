//
//  HeaderCell.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/8/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
}
