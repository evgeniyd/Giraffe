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
        let image = self.model.multiFrame()
        
        self.isActive.producer
            .filter { $0 }
            .mapError { _ in
                return GiraffeError.UnknownError
            }
            .flatMap(.Latest) { _ in
                return image.get()
            }
            .startWithResult { result in
                print(result)
                self.image.value = result.value
                
        }
    }
}
