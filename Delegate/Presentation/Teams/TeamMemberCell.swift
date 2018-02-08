//
//  TeamMemberCell.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/8/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import SDWebImage

class TeamMemberCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dissmiseButton: UIButton!

//    var model: TeamMember! {
//        didSet {
//            configureOutlets(model: model)
//        }
//    }
//    
//    fileprivate func configureOutlets(model: TeamMember)
//    {
//        if let link = model.avatarLink, let url = URL(string: link) {
//             logoImageView.sd_setImage(with: url, placeholderImage: nil, options: .scaleDownLargeImages, progress: nil, completed: nil)
//        }
//        titleLabel.text = model.name
//        detailsLabel.text = model.position
//        
//        switch model.state! {
//        case .invitePending:
//            configureButtons(targetButton: cancelButton)
//        case .inviteAccepted:
//            configureButtons(targetButton: dissmiseButton)
//        default:
//            configureButtons(targetButton: inviteButton)
//        }
//    }
//    
//    fileprivate func configureButtons(targetButton: UIButton)
//    {
//        let buttons = [inviteButton, cancelButton, dissmiseButton]
//        for button in buttons {
//            button?.isHidden = button! != targetButton
//        }
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        logoImageView.image = nil
//        titleLabel.text = nil
//        detailsLabel.text = nil
//    }

}
