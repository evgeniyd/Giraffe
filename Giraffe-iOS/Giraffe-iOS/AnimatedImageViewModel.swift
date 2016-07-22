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
import NukeAnimatedImagePlugin

struct AnimatedImageViewModel {
    
    typealias GiraffeImage = GiraffeKit.Image
    typealias NukeImage = Nuke.Image
    
    private let model: Item
    
    let isActive  = MutableProperty<Bool>(false)
    
    let staticImage = MutableProperty<NukeImage?>(nil)
    
    init(model: Item) {
        self.model = model
        // Setup RAC bindings.
        self.setupBindings()
    }
    
    private func setupBindings() {
        
        let singleFrameImage = self.model.singleFrame()
        
//        let multiFrameImage = framableItem.multiFrame()
        
        self.isActive.producer
            .filter { $0 }
            .mapError { _ in
                return GiraffeError.UnknownError
            }
            .flatMap(.Latest) { _ in
                return self.get(singleFrameImage)
            }
            .startWithResult { result in
                self.staticImage.value = result.value!
        }
    }
    
    func get(image: GiraffeImage) -> SignalProducer<NukeImage, GiraffeError> { // TODO: change GiraffeError -> APIError
        let imageURL = image.url
        let request = ImageRequest(URL: imageURL)
        
        return SignalProducer { observer, disposable in
            let task: ImageTask = Nuke.taskWith(request) { response in
                switch response {
                case .Success(let image, /*let info*/_):
                    observer.sendNext(image)
                    observer.sendCompleted()
                case .Failure(let error ):
                    let nsError: NSError = error as NSError
                    if nsError.domain == Nuke.ImageManagerErrorDomain
                        && nsError.code == Nuke.ImageManagerErrorCode.Cancelled.rawValue {
                            observer.sendInterrupted()
                    } else {
                        print("Error while loading images. Error was:\n\(error)")
                        observer.sendFailed(GiraffeError.NetworkError)
                    }
                    
                }
            }.resume()
            
            disposable.addDisposable(task.rac_cancel)
        }
    }
}

extension ImageTask {
    public func rac_cancel() {
        _ = self.cancel()
    }
}
