//
//  Observable+JSON.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/3/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import RxSwift
import SwiftyJSON

extension Observable where Element == Data {
    func mapJSON() -> Observable<JSON> {
        return map { JSON(data: $0) }
    }
}
