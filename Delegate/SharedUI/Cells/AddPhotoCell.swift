//
//  AddPhotoCell.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/25/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class AddPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deletePhotoBtn: UIButton!
    
    var closure: (() -> ())?
    
    fileprivate let placeholder = #imageLiteral(resourceName: "add_logo_icon")
    fileprivate var hasPhoto = false
    
    var offerPicture: UIImage? {
        didSet {
            guard let picture = offerPicture else { return }
            prepareAppearance(forPlaceholder: false, with: picture)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.borderWidth = hasPhoto ? 0.0 : 1.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepareAppearance(forPlaceholder: true, with: placeholder)
    }
    
    fileprivate func prepareAppearance(forPlaceholder bool: Bool, with photo: UIImage)
    {
        hasPhoto = !bool
        deletePhotoBtn.isHidden = !hasPhoto
        imageView.image = photo
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = hasPhoto ? 0.0 : 1.0
        imageView.contentMode = hasPhoto ? .scaleAspectFill : .center
    }
    
    @IBAction func onPressedClearPictureBtn(_ sender: Any)
    {
        closure?()
    }
}
