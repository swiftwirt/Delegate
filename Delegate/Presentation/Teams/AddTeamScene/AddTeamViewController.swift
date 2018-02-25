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

class AddTeamViewController: UIViewController {

    @IBOutlet private weak var makerTextField: DelegateTextField!
    @IBOutlet private weak var modelTextField: DelegateTextField!
    @IBOutlet private weak var bodyTypeTextField: DelegateTextField!
    @IBOutlet private weak var yearTextField: DelegateTextField!
    @IBOutlet private weak var lengthTextField: DelegateTextField!
    @IBOutlet private weak var plateNumberTextField: DelegateTextField!
    @IBOutlet private weak var colorTextField: DelegateTextField!
    @IBOutlet private weak var photosCollectionView: UICollectionView!
    @IBOutlet private weak var createButton: UIButton!

    private lazy var makerPickerView = UIPickerView()
    private lazy var bodyTypePickerView = UIPickerView()
    private lazy var yearPickerView = UIPickerView()

    var output: AddTeamInteractor!

    lazy var applicationManager: ApplicationManager = {
        return self.output.applicationManager
    }()

    private let disposeBag: DisposeBag = DisposeBag()
    private var model: CreateTeamModel = CreateTeamModel() {
        didSet {
            photosCollectionView.reloadData()
        }
    }
    private let metersShortcut = "m"

    override func viewDidLoad() {
        super.viewDidLoad()

        AddTeamConfigurator.configure(self)
        setupTextFields()
        setupPickers()
        observeSubmitTaps()
        configurePlaceholders()
    }

    fileprivate func configurePlaceholders() {
        makerTextField.placeholder = BetoshookStrings.maker
        modelTextField.placeholder = BetoshookStrings.model
        bodyTypeTextField.placeholder = BetoshookStrings.body
        yearTextField.placeholder = BetoshookStrings.year
        lengthTextField.placeholder = BetoshookStrings.length
        plateNumberTextField.placeholder = BetoshookStrings.plate
        colorTextField.placeholder = BetoshookStrings.color
    }

    func prepareForEditing(team: Team) {
        loadViewIfNeeded()

        navigationItem.title = BetoshookStrings.editteamNavigationTitle

        model = CreateteamModel(team: team)

        makerTextField.text = model.teamBrand?.displayName
        modelTextField.text = model.model
        bodyTypeTextField.text = model.vehicleType?.displayName
        if let year = model.yearOfProduction {
            yearTextField.text = "\(year)"
        }
        if let length = model.teamLength {
            lengthTextField.text = BetoshookFormatters.getFormattedDouble(double: length) + metersShortcut
        }
        plateNumberTextField.text = model.teamNumber
        colorTextField.text = model.teamColor

        if let teamBrand = model.teamBrand, let rowIndex = teamBrand.allValues.index(of: teamBrand) {
            makerPickerView.selectRow(rowIndex, inComponent: 0, animated: false)
        }
        if let vehicleType = model.vehicleType, let rowIndex = VehicleType.allValues.index(of: vehicleType) {
            bodyTypePickerView.selectRow(rowIndex, inComponent: 0, animated: false)
        }
        if let year = model.yearOfProduction, let rowIndex = Array(BetoshookConstants.teamYearsRange.reversed()).index(of: Int(year)) {
            yearPickerView.selectRow(rowIndex, inComponent: 0, animated: false)
        }

        let textFields: [BetoshookTextField] = [makerTextField, modelTextField, bodyTypeTextField, yearTextField, lengthTextField, plateNumberTextField, colorTextField]
        for textField in textFields {
            textField.validationState = .valid
        }
    }

    private func setupTextFields() {
        let responderChain: [BetoshookTextField] = [makerTextField, modelTextField, bodyTypeTextField, yearTextField, lengthTextField, plateNumberTextField, colorTextField]

        for (index, textField) in responderChain.dropLast().enumerated() {
            textField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {
                _ = responderChain[index + 1].becomeFirstResponder()
            }).disposed(by: disposeBag)
        }

        responderChain.last?.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)

        let requiredFields: [BetoshookTextField] = [makerTextField, modelTextField, bodyTypeTextField, yearTextField, plateNumberTextField, colorTextField]
        for textField in requiredFields {
            textField.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit]).subscribe(onNext: {
                if textField.hasText {
                    textField.validationState = .valid
                } else {
                    textField.validationState = .invalid(errorMessage: nil)
                }
            }).disposed(by: disposeBag)
        }

        let optionalFields: [BetoshookTextField] = [lengthTextField]
        for textField in optionalFields {
            textField.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit]).subscribe(onNext: {
                if textField.hasText {
                    textField.validationState = .valid
                } else {
                    textField.validationState = .undefined
                }
            }).disposed(by: disposeBag)
        }

        modelTextField.rx.text.subscribe(onNext: { [weak self] text in
            self?.model.model = text
        }).disposed(by: disposeBag)

        lengthTextField.rx.text.subscribe(onNext: { [weak self] text in

            guard let StrongSelf = self, let text = text, let textField = self?.lengthTextField else {
                self?.model.teamLength = nil
                return
            }

            let filteredText = text.replacingOccurrences(of: StrongSelf.metersShortcut, with: "")
            if filteredText.isEmpty {
                textField.text = nil
            } else {
                let selectedRange = textField.selectedTextRange
                textField.text = filteredText + StrongSelf.metersShortcut
                textField.selectedTextRange = selectedRange
            }
            self?.model.teamLength = BetoshookFormatters.parseDouble(from: filteredText)
        }).disposed(by: disposeBag)

        plateNumberTextField.rx.text.subscribe(onNext: { [weak self] text in
            guard let StrongSelf = self, let aText = text, let numberString = aText.getNumFromString(), numberString.count <= BetoshookConstants.maxNumberOfCharactersInPlateNumber else {
                self?.plateNumberTextField.text = String(text?.prefix(BetoshookConstants.maxNumberOfCharactersInPlateNumber) ?? "")
                return
            }
            StrongSelf.plateNumberTextField.text = numberString
            StrongSelf.model.teamNumber = numberString
        }).disposed(by: disposeBag)

        colorTextField.rx.text.subscribe(onNext: { [weak self] text in
            self?.model.teamColor = text
        }).disposed(by: disposeBag)
    }

    private func setupPickers() {
        let pickers: [UIView] = [makerPickerView, bodyTypePickerView, yearPickerView]
        for picker in pickers {
            picker.backgroundColor = UIColor.white
        }

        Observable.just(teamBrand.allValues).bind(to: makerPickerView.rx.customFontLabels) { row, brand, label in
            label.text = brand.displayName
        }.disposed(by: disposeBag)

        makerPickerView.rx.modelSelected(teamBrand.self).map { $0[0] }.subscribe(onNext: { [weak self] teamBrand in
            self?.model.teamBrand = teamBrand
            self?.makerTextField.text = teamBrand.displayName
            self?.makerTextField.validationState = .valid
        }).disposed(by: disposeBag)

        makerTextField.inputView = makerPickerView

        Observable.just(VehicleType.allValues).bind(to: bodyTypePickerView.rx.customFontLabels) { row, type, label in
            label.text = type.displayName
        }.disposed(by: disposeBag)

        bodyTypePickerView.rx.modelSelected(VehicleType.self).map { $0[0] }.subscribe(onNext: { [weak self] vehicleType in
            self?.model.vehicleType = vehicleType
            self?.bodyTypeTextField.text = vehicleType.displayName
            self?.bodyTypeTextField.validationState = .valid
        }).disposed(by: disposeBag)

        bodyTypeTextField.inputView = bodyTypePickerView

        Observable.just(BetoshookConstants.teamYearsRange.reversed()).bind(to: yearPickerView.rx.customFontLabels) { row, year, label in
            label.text = "\(year)"
        }.disposed(by: disposeBag)

        yearPickerView.rx.modelSelected(Int.self).map { $0[0] }.subscribe(onNext: { [weak self] year in
            self?.model.yearOfProduction = UInt(year)
            self?.yearTextField.text = "\(year)"
            self?.yearTextField.validationState = .valid
        }).disposed(by: disposeBag)

        yearTextField.inputView = yearPickerView
    }

    private func observeSubmitTaps() {
        createButton.rx.tap.takeUntil(self.rx.deallocated).flatMapLatest { [unowned self] () -> Observable<CreateteamModel> in
            guard self.model.isValid else {
                self.showValidationErrors()
                return Observable.empty()
            }

            HUD.show(.progress)

            if let photo = self.model.teamPhoto, case .image(let image) = photo {
                return self.applicationManager.apiService.uploadteamPhoto(image).takeUntil(self.rx.deallocated).map { [unowned self] json in
                    guard let json = json, let url = json[JSONKey.url].string else {
                        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to upload photo"])
                    }

                    self.model.teamPhoto = .url(url)
                    return self.model
                }.catchError { error in
                    HUD.flash(.labeledError(title: BetoshookErrorMessage.error, subtitle: error.localizedDescription))
                    return Observable.empty()
                }
            } else {
                return Observable.just(self.model)
            }
        }.takeUntil(self.rx.deallocated).flatMapLatest { [unowned self] model -> Observable<JSON> in
            guard model.isValid else {
                self.showValidationErrors()
                return Observable.empty()
            }

            let team = Team(with: model)

            let requestObservable: Observable<JSON>
            if team.id != nil {
                requestObservable = self.applicationManager.apiService.editteam(team)
            } else {
                team.isDefault = self.applicationManager.userService.user?.betoparkInfo?.teams.filter { $0.isDefault == true }.count == 0
                requestObservable = self.applicationManager.apiService.AddTeam(team)
            }

            return requestObservable.catchError { error in
                HUD.flash(.labeledError(title: BetoshookErrorMessage.error, subtitle: error.localizedDescription))
                return Observable.empty()
            }
        }.subscribe(onNext: { [weak self] json in
            self?.applicationManager.userService.user?.betoparkInfo?.updateUserteams(withProfile: json)
            HUD.flash(.success)
            self?.updateProfileActiveIfNeeded()
            self?.returnBack()
        }).disposed(by: disposeBag)
    }

    private func updateProfileActiveIfNeeded() {
        guard let user = applicationManager.userService.user else {
            return
        }

        if user.betojobInfo?.active == true && user.betoparkInfo?.active != true {
            user.betoparkInfo?.active = true

            _ = applicationManager.apiService.updateUser(user).subscribe()
        }
    }

    private func showValidationErrors() {
        let requiredFields: [BetoshookTextField] = [makerTextField, modelTextField, bodyTypeTextField, yearTextField, plateNumberTextField, colorTextField]
        for textField in requiredFields {
            if !textField.hasText {
                textField.validationState = .invalid(errorMessage: nil)
            }
        }
    }
}

extension AddTeamViewController { // Actions
    @IBAction private func onAddPhotoPressed() {
        output.takePhoto()
    }
}

extension AddTeamViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.teamPhoto == nil ? 0 : 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.cell, for: indexPath)

        if let photoCell = cell as? AddOfferPhotoCollectionViewCell {
            if let teamPhoto = model.teamPhoto {
                switch teamPhoto {
                case .image(let image):
                    photoCell.offerPicture = image
                case .photo(let photo):
                    if let url = photo.url {
                        SDWebImageManager.shared().loadImage(with: URL(string: url), options: [], progress: nil, completed: { image, _, _, _, _, _ in
                            photoCell.offerPicture = image
                        })
                    }
                case .url(let url):
                    SDWebImageManager.shared().loadImage(with: URL(string: url), options: [], progress: nil, completed: { image, _, _, _, _, _ in
                        photoCell.offerPicture = image
                    })
                }
            }
            photoCell.closure = { [weak self] in
                self?.model.teamPhoto = nil
            }
        }
        return cell
    }
}

extension AddTeamViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        let targetSize = CGSize(width: 640.0, height: 640.0)
        if let compressedImage = image.resizeImage(targetSize: targetSize) {
            model.teamPhoto = .image(compressedImage)
        }
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension AddTeamViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case makerTextField:
            if model.teamBrand == nil, let teamBrand = teamBrand.allValues.first {
                model.teamBrand = teamBrand
                makerTextField.text = teamBrand.displayName
                makerTextField.validationState = .valid
            }
        case bodyTypeTextField:
            if model.vehicleType == nil, let vehicleType = VehicleType.allValues.first {
                model.vehicleType = vehicleType
                bodyTypeTextField.text = vehicleType.displayName
                bodyTypeTextField.validationState = .valid
            }
        case yearTextField:
            if model.yearOfProduction == nil, let year = BetoshookConstants.teamYearsRange.reversed().first {
                model.yearOfProduction = UInt(year)
                yearTextField.text = "\(year)"
                yearTextField.validationState = .valid
            }
        default:
            break
        }

        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case modelTextField:
            model.model = nil
            view.endEditing(true)
            return true
        case colorTextField:
            model.teamColor = nil
            view.endEditing(true)
            return true
        case lengthTextField:
            model.teamLength = nil
            view.endEditing(true)
            return true
        case plateNumberTextField:
            model.teamNumber = nil
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
