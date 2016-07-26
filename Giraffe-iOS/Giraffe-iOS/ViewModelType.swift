//
//  ViewModelType.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/16/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import GiraffeKit

protocol ViewModelType {
    var isActive: MutableProperty<Bool> { get }
    var message: MutableProperty<String> { get }
    var shouldHideItemsView: MutableProperty<Bool> { get }
    var itemViewModels: MutableProperty<[AnimatedImageViewModel]> { get }
}
