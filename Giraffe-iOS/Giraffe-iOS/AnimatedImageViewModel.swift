//
//  AnimatedImageViewModel.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/18/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import GiraffeKit

struct AnimatedImageViewModel: ViewModelType {
    private let model: Item
    
    let isActive  = MutableProperty<Bool>(false)
    
    init(model: Item) {
        self.model = model
        // Setup RAC bindings.
        self.setupBindings()
    }
    
    private func setupBindings() {
        self.isActive.producer
            .filter { $0 }
            .mapError { _ in
                return GiraffeError.UnknownError
            }
            .flatMap(.Latest) { _ in
                // return SignalProducer<LocalPathWhereImageIsStored, ErrorType>
            }
            .startWithResult { result in
                // process the result
        }
    }
}
