//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AddTeamInteractor {
    
    var output: AddTeamPresenter!

    fileprivate let disposeBag = DisposeBag()

    let applicationManager = ApplicationManager.instance()
    
    var model: CreateTeamModel = CreateTeamModel() {
        didSet {
            output.reloadCollectionView()
        }
    }
    
    func setupTextFields() {
        
        for (index, responder) in output.responderChain.enumerated() {
            let endEditingEvent: ControlEvent<Void>?
            
            switch responder {
            case let control as UIControl:
                endEditingEvent = control.rx.controlEvent(.editingDidEndOnExit)
            case let textView as DelegateTextView:
                endEditingEvent = textView.uiControlComposition.rx.controlEvent(.editingDidEndOnExit)
            default:
                endEditingEvent = nil
            }
            
            endEditingEvent?.subscribe(onNext: {
                if index == self.output.responderChain.count - 1 {
                    _ = responder.resignFirstResponder()
                } else {
                    _ = self.output.responderChain[index + 1].becomeFirstResponder()
                }
            }).disposed(by: disposeBag)
            
        }
        
        
        for field in output.requiredFields {
            switch field {
            case let textField as DelegateTextField:
                textField.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit]).subscribe(onNext: {
                    if textField.hasText {
                        textField.validationState = .valid
                    } else {
                        textField.validationState = .invalid(errorMessage: nil)
                    }
                }).disposed(by: disposeBag)
            case let textView as DelegateTextView:
                textView.rx.didEndEditing.subscribe(onNext: {
                    if textView.hasText {
                        textView.validationState = .valid
                    } else {
                        textView.validationState = .invalid(errorMessage: nil)
                    }
                }).disposed(by: disposeBag)
            default:
                break
            }
        }
        
        
        for field in output.optionalFields {
            switch field {
            case let textField as DelegateTextField:
                textField.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit]).subscribe(onNext: {
                    if textField.hasText {
                        textField.validationState = .valid
                    } else {
                        textField.validationState = .undefined
                    }
                }).disposed(by: disposeBag)
            case let textView as DelegateTextView:
                textView.rx.didEndEditing.subscribe(onNext: {
                    if textView.hasText {
                        textView.validationState = .valid
                    } else {
                        textView.validationState = .undefined
                    }
                }).disposed(by: disposeBag)
            default:
                break
            }
        }
    }

    func takePhoto()
    {
        output.showImagePicker(manager: applicationManager.imagePickerService)
        applicationManager.imagePickerService.observableImage.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (image) in
            self?.output?.presentCropViewController(with: image)
        }, onError: { (error) in
            print(error)
        }).disposed(by: disposeBag)
    }
}
