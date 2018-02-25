//
//  TeamCell.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/8/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import SDWebImage

class TeamCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var membersNumberLabel: UILabel!
    
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
//    var model: Team! {
//        didSet {
//            configureOutlets(model: model)
//        }
//    }
//    
//    func configureOutlets(model: Team)
//    {
//        if let link = model.logoLink, let url = URL(string: link) {
//            logoImageView.sd_setImage(with: url, placeholderImage: nil, options: .scaleDownLargeImages, progress: nil, completed: nil)
//        }
//        titleLabel.text = model.title
//        detailsLabel.text = model.details
//        membersNumberLabel.text = String((model.members?.count ?? 0))
//        
//        switch model.state! {
//        case .invitePending:
//            configureButtons(targetButton: joinButton)
//        case .inviteAccepted:
//            configureButtons(targetButton: leaveButton)
//        default:
//            configureButtons(targetButton: dismissButton)
//        }
//    }
//    
//    fileprivate func configureButtons(targetButton: UIButton)
//    {
//        let buttons = [joinButton, leaveButton, dismissButton]
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
//        membersNumberLabel.text = nil
//    }
}
