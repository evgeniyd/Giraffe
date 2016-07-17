//
//  AnimatedImageViewModel.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/18/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import GiraffeKit

protocol AnimatedImageViewModelType {
    init(model: DataItem)
}

struct AnimatedImageViewModel: AnimatedImageViewModelType {
    private let model: DataItem
    
    init(model: DataItem) {
        self.model = model
    }
}
