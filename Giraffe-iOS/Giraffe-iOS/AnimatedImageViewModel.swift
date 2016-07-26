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
import Nuke

struct AnimatedImageViewModel {
    private let model: Item
    
    let isActive  = MutableProperty<Bool>(false)
    let image = MutableProperty<NukeImage?>(nil)
    
    init(model: Item) {
        self.model = model
        self.setupBindings()
    }
    
    private func setupBindings() {
        self.isActive.producer
            .filter { $0 } // TODO: cancel work upon 'false'
            .mapError { _ in
                return GiraffeError.UnknownError
            }
            .flatMap(.Latest) { _ in
                return self.model.multiFrame().get()
            }
            .startWithResult { result in
                print(result)
                self.image.value = result.value
                
        }
    }
}
