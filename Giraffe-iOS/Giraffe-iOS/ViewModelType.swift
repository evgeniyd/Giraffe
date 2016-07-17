//
//  ViewModelType.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/16/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import ReactiveCocoa

protocol ViewModelType {
    var isActive: MutableProperty<Bool> { get }
}
