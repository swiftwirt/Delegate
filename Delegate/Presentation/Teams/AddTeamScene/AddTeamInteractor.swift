//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation
import RxSwift

class AddTeamInteractor {
    
    private enum ReuseIdentifier {
        static let cell = "AddPictureCell"
    }
    
    var output: AddTeamPresenter!

    fileprivate let disposeBag = DisposeBag()

    let applicationManager = ApplicationManager.instance()

    func takePhoto()
    {
        output.showImagePicker()
        applicationManager.imagePickerService.observableImage.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (image) in
            self?.output?.presentCropViewController(with: image)
        }, onError: { (error) in
            print(error)
        }).disposed(by: disposeBag)
    }
}
