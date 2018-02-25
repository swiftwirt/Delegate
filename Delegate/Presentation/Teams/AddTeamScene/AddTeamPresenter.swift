//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation
import TOCropViewController

class AddTeamPresenter {
    weak var output: AddTeamViewController!

    func presentCropViewController(with image: UIImage?)
    {
        guard let picture = image else { return }
        let controller = TOCropViewController(croppingStyle: .default, image: picture)
        controller.aspectRatioPreset = .preset16x9
        controller.aspectRatioLockEnabled = true
        controller.resetAspectRatioEnabled = false

        controller.toolbar.cancelTextButton.setImage(#imageLiteral(resourceName:"icon_cross"), for: .normal)
        controller.toolbar.doneTextButton.tintColor = .red
        controller.toolbar.cancelTextButton.setTitle("", for: .normal)

        controller.toolbar.doneTextButton.setImage(#imageLiteral(resourceName:"icon_checkmark"), for: .normal)
        controller.toolbar.doneTextButton.tintColor = .green
        controller.toolbar.doneTextButton.setTitle("", for: .normal)

        controller.delegate = output
        output.present(controller, animated: true, completion: nil)
    }

    func showImagePicker()
    {
        output.applicationManager.imagePickerService.fireImagePicker(in: output)
    }
}
