//
//  SettingsScreenPresenter.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/13/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import SDWebImage
import TOCropViewController
import RxSwift

class SettingsScreenPresenter: NSObject {
    
    weak var output: SettingsTableViewController!
    
    fileprivate let applicationManager = ApplicationManager.instance()
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    
    fileprivate let shiftDueToDisclosure = 18.0
    fileprivate let avatarCompressDimensions = 400.0
    
    fileprivate var newCompressedAvatar: UIImage? {
        didSet {
            guard let image = newCompressedAvatar else { return }
            ApplicationManager.instance().apiService.saveAdded(avatar: image).subscribe(onNext: { [ weak self ] (link) in
                self?.applicationManager.userService.user?.avatarLink = link
                self?.setAvatar(link: link)
            }).disposed(by: disposeBag)
        }
    }
    
    var witchersChain: [UISwitch]
    {
        return [
            output.adsSwitcher,
            output.congratulationsSwitcher,
            output.localNotificationsSwitcher,
            output.pushSwitcher
            ]
    }
    
    func setAvatar(link: String?)
    {
        guard let link = link, let url = URL(string: link) else { return }
        output.userAvatarImageView.sd_setShowActivityIndicatorView(true)
        output.userAvatarImageView.sd_setIndicatorStyle(.gray)
        output.userAvatarImageView.sd_setImage(with: url) { [weak self] (_, error, _, _) in
            if let StrongSelf = self, error == nil {
                StrongSelf.output.userAvatarImageView.layer.cornerRadius = StrongSelf.output.userAvatarImageView.frame.width / 2
            }
        }
    }
    
    func initialSetup(native: Bool?, userName: String, email: String?, settings: Settings? = nil)
    {
        if native != nil, !native! {
            output.profileCell.accessoryType = .none
            output.editAvatarButton.isHidden = true
            output.profileCell.isUserInteractionEnabled = false
        }
        output.profileInfoCenterConstraint.constant = CGFloat((native ?? false) ? shiftDueToDisclosure : 0.0)
        output.userNameLabel.text = userName
        output.userEmailLabel.text = email
        guard settings != nil else { return }
        configureSwitchers(with: settings!)
    }
    
    fileprivate func configureSwitchers(with model: Settings)
    {
        output.adsSwitcher.isOn = model.needsAds!
        output.congratulationsSwitcher.isOn = model.congratulations!
        output.pushSwitcher.isOn = model.push!
        output.localNotificationsSwitcher.isOn = model.localNotifications!
    }
    
    // Image Picker
    
    func presentCropViewController(with image: UIImage?)
    {
        guard let picture = image else { return }
        let controller = TOCropViewController(croppingStyle: .circular, image: picture)
        
        controller.toolbar.cancelTextButton.setImage(#imageLiteral(resourceName: "icon_cross"), for: .normal)
        controller.toolbar.doneTextButton.tintColor = .red
        controller.toolbar.cancelTextButton.setTitle("", for: .normal)
        
        controller.toolbar.doneTextButton.setImage(#imageLiteral(resourceName: "icon_checkmark"), for: .normal)
        controller.toolbar.doneTextButton.tintColor = .green
        controller.toolbar.doneTextButton.setTitle("", for: .normal)
        
        controller.delegate = self
        output.present(controller, animated: true, completion: nil)
    }
    
    func showImagePicker(applicationManager: ApplicationManager)
    {
        applicationManager.imagePickerService.fireImagePicker(in: output)
    }
}

extension SettingsScreenPresenter: TOCropViewControllerDelegate
{
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        
        let targetSize = CGSize(width: avatarCompressDimensions, height: avatarCompressDimensions)
        if let compressedImage = image.resizeImage(targetSize: targetSize) {
            newCompressedAvatar = compressedImage
        }
        
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
