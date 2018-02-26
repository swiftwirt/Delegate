//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import TOCropViewController
import RxSwift
import RxCocoa
import PKHUD
import SDWebImage
import SwiftyJSON

class AddTeamViewController: DelegateAbstractViewController {
    
    private enum ReuseIdentifier
    {
        static let cell = "AddPhotoCell"
    }
    
    @IBOutlet weak var titleTextField: DelegateFloatingLabelTextField!
    @IBOutlet weak var detailsTextView: DelegateTextView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var createButton: UIButton!
    
    var output: AddTeamInteractor!
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddTeamConfigurator.configure(self)
        output.setupTextFields()
        observeInputEvents()
        observeSubmitTaps()
        configurePlaceholders()
    }
    
    fileprivate func configurePlaceholders() {
        titleTextField.placeholder = Strings.title
        detailsTextView.placeholder = Strings.details
    }
    
    func prepareForEditing(team: Team) {
        loadViewIfNeeded()
        
        output.model = CreateTeamModel(team: team)
        
        titleTextField.text = output.model.title
        detailsTextView.text = output.model.teamDetails
    }
    
    fileprivate func observeInputEvents()
    {
        titleTextField.rx.text.subscribe(onNext: { [weak self] text in
            self?.output.model.title = text
        }).disposed(by: disposeBag)
        
        detailsTextView.rx.text.subscribe(onNext: { [weak self] text in
            self?.output.model.teamDetails = text
        }).disposed(by: disposeBag)
    }
    
    private func observeSubmitTaps() {
        //        createButton.rx.tap.takeUntil(self.rx.deallocated).flatMapLatest { [unowned self] () -> Observable<CreateTeamModel> in
        //            guard self.model.isValid else {
        //                self.showValidationErrors()
        //                return Observable.empty()
        //            }
        //
        //            HUD.show(.progress)
        //
        //            if let photo = self.model.teamPhoto, case .image(let image) = photo {
        //                return self.applicationManager.apiService.uploadteamPhoto(image).takeUntil(self.rx.deallocated).map { [unowned self] json in
        //                    guard let json = json, let url = json[JSONKey.url].string else {
        //                        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to upload photo"])
        //                    }
        //
        //                    self.model.teamPhoto = .url(url)
        //                    return self.model
        //                }.catchError { error in
        //                    HUD.flash(.labeledError(title: BetoshookErrorMessage.error, subtitle: error.localizedDescription))
        //                    return Observable.empty()
        //                }
        //            } else {
        //                return Observable.just(self.model)
        //            }
        //        }.takeUntil(self.rx.deallocated).flatMapLatest { [unowned self] model -> Observable<JSON> in
        //            guard model.isValid else {
        //                self.showValidationErrors()
        //                return Observable.empty()
        //            }
        //
        //            let team = Team(with: model)
        //
        //            let requestObservable: Observable<JSON>
        //            if team.id != nil {
        //                requestObservable = self.applicationManager.apiService.editteam(team)
        //            } else {
        //                team.isDefault = self.applicationManager.userService.user?.betoparkInfo?.teams.filter { $0.isDefault == true }.count == 0
        //                requestObservable = self.applicationManager.apiService.AddTeam(team)
        //            }
        //
        //            return requestObservable.catchError { error in
        //                HUD.flash(.labeledError(title: BetoshookErrorMessage.error, subtitle: error.localizedDescription))
        //                return Observable.empty()
        //            }
        //        }.subscribe(onNext: { [weak self] json in
        //            self?.applicationManager.userService.user?.betoparkInfo?.updateUserteams(withProfile: json)
        //            HUD.flash(.success)
        //            self?.updateProfileActiveIfNeeded()
        //            self?.returnBack()
        //        }).disposed(by: disposeBag)
    }
    
    private func showValidationErrors() {
        let requiredFields: [DelegateTextField] = [titleTextField]
        for textField in requiredFields {
            if !textField.hasText {
                textField.validationState = .invalid(errorMessage: nil)
            }
        }
    }
}

extension AddTeamViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        assert(indexPath.row == 0)
        output.takePhoto()
    }
}

extension AddTeamViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.cell, for: indexPath)
        
        if let photoCell = cell as? AddPhotoCell {
            if let teamPhoto = output.model.teamPhoto {
                switch teamPhoto {
                case .image(let image):
                    photoCell.offerPicture = image
                case .url(let url):
                    SDWebImageManager.shared().loadImage(with: URL(string: url), options: [], progress: nil, completed: { image, _, _, _, _, _ in
                        photoCell.offerPicture = image
                    })
                }
            }
            photoCell.closure = { [weak self] in
                self?.output.model.teamPhoto = nil
            }
        }
        return cell
    }
}

extension AddTeamViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        let targetSize = CGSize(width: 640.0, height: 640.0)
        if let compressedImage = image.resizeImage(targetSize: targetSize) {
            output.model.teamPhoto = .image(compressedImage)
        }
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension AddTeamViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case titleTextField:
            output.model.title = nil
            view.endEditing(true)
            return true
        default:
            return true
        }
    }
}

extension AddTeamViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = 109 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 0 * (collectionView.numberOfItems(inSection: 0) - 1)
        
        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        
    }
}
