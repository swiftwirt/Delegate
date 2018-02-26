//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation
import RxDataSources

enum CreateImageModel
{
    case image(UIImage)
    case url(String)
    case photo(URL)
}

extension CreateImageModel: Equatable {
    
    static func ==(lhs: CreateImageModel, rhs: CreateImageModel) -> Bool
    {
        switch (lhs, rhs) {
        case (.image(let image1), .image(let image2)):
            return image1 == image2
        case (.url(let url1), .url(let url2)):
            return url1 == url2
        case (.photo(let photo1), .photo(let photo2)):
            return photo1 == photo2
        default:
            return false
        }
    }
}

extension CreateImageModel: Hashable {
    
    var hashValue: Int
    {
        switch self {
        case .image(let image):
            return image.hashValue
        case .url(let url):
            return url.hashValue
        case .photo(let photo):
            return photo.hashValue
        }
    }
}

extension CreateImageModel: IdentifiableType {
    
    var identity: CreateImageModel
    {
        return self
    }
}
