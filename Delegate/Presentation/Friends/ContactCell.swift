//
//  ContactCell.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/9/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import SDWebImage
import Contacts

class ContactCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dissmiseButton: UIButton!
    
    var contact: CNContact? = nil {
        didSet {
            titleLabel.text = contact!.givenName + " " + contact!.middleName + " " + contact!.familyName
            emailLabel.text = (contact?.phoneNumbers.first?.value)?.stringValue
            inviteButton.isHidden = false
            cancelButton.isHidden = true
            dissmiseButton.isHidden = true
        }
    }

}
