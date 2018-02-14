//
//  ImagePickingService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/13/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import RxSwift
import LEMirroredImagePicker

class ImagePickerService: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    fileprivate var subject: PublishSubject<UIImage?>!
    
    fileprivate weak var viewController: UIViewController!
    fileprivate let mirroredPickerController = LEMirroredImagePicker()
    
    var observableImage: Observable<UIImage?> {
        get {
            return subject
        }
    }
    
    func fireImagePicker(in viewController: UIViewController)
    {
        self.viewController = viewController
        subject = PublishSubject<UIImage?>()
        
        let cameraButtonAction = UIAlertAction(title: Strings.cameraTitle, style: UIAlertActionStyle.default) { (UIAlertAction) in
            self.shootPhoto()
        }
        
        let galleryButtonAction = UIAlertAction(title: Strings.galleryTitle, style: UIAlertActionStyle.default) { (UIAlertAction) in
            self.selectImageFromLibrary()
        }
        
        let cancelButtonAction = UIAlertAction(title: Strings.cancelTitle, style: UIAlertActionStyle.cancel) { (UIAlertAction) in
        }
        
        let actions = [cameraButtonAction, galleryButtonAction, cancelButtonAction]
        AlertHandler.showSpecialActionSheet(in: viewController, with: Strings.photoActionSheetTitle, actions: actions)
    }
    
    fileprivate func selectImageFromLibrary()
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        viewController.dismiss(animated: true, completion: { () -> Void in
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.subject.on(.next(image))
                self.subject.onCompleted()
            } else {
                // TODO: - handle error
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        subject.onCompleted()
        viewController.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func shootPhoto()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .camera
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.modalPresentationStyle = .fullScreen
            imagePickerController.delegate = self
            mirroredPickerController.imagePickerController = imagePickerController
            mirroredPickerController.mirrorFrontCamera()
            viewController.present(imagePickerController, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    fileprivate func noCamera()
    {
        let noCameraAlertVC = UIAlertController(title: ErrorMessage.noCameraTitle, message: ErrorMessage.noCameraMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        noCameraAlertVC.addAction(okAction)
        viewController.present(noCameraAlertVC, animated: true, completion: nil)
    }
    
}

