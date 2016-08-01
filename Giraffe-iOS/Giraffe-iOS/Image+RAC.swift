//
//  Image+RAC.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/22/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import GiraffeKit
import ReactiveCocoa
import Nuke
import NukeAnimatedImagePlugin

typealias GiraffeImage = GiraffeKit.Image
typealias NukeImage = Nuke.Image

// MARK: RAC gettable image -

protocol ImageGettable {
    func get() -> SignalProducer<NukeImage, GiraffeError>
}

// MARK: Default ImageGettable implementation for GiraffeImage -

extension GiraffeImage: ImageGettable {
    func get() -> SignalProducer<NukeImage, GiraffeError> {
        dispatch_once(&Static.dispatchOnceToken) {
            ImageManager.shared = ImageManager.configuredForAnimatedImages()
        }
        
        let imageURL = self.url
        let request = ImageRequest(URL: imageURL)
        
        return SignalProducer { observer, disposable in
            let task: ImageTask = Nuke.taskWith(request) { response in
                switch response {
                case .Success(let image, _):
                    observer.sendNext(image)
                    observer.sendCompleted()
                case .Failure(let error ):
                    let nsError: NSError = error as NSError
                    if nsError.domain == Nuke.ImageManagerErrorDomain
                        && nsError.code == Nuke.ImageManagerErrorCode.Cancelled.rawValue {
                        observer.sendInterrupted()
                    } else {
                        observer.sendFailed(GiraffeError.LoadImageError(nsError.localizedDescription))
                    }
                    
                }
                }.resume()
            
            disposable.addDisposable(task.rac_cancel)
        }
    }
    
    private struct Static {
        static var dispatchOnceToken: dispatch_once_t = 0
    }
}

// MARK: Nuke Extensions -

extension ImageManager {
    public static func configuredForAnimatedImages() -> ImageManager {
        let decoder = ImageDecoderComposition(decoders: [AnimatedImageDecoder(), ImageDecoder()])
        let cache = AnimatedImageMemoryCache()
        // TODO: tune app ImageDataLoader()
        let animatedImageLoaderConfiguration = ImageLoaderConfiguration(dataLoader: ImageDataLoader(), decoder: decoder)
        let loader = ImageLoader(configuration: animatedImageLoaderConfiguration, delegate: AnimatedImageLoaderDelegate())
        return ImageManager(configuration: ImageManagerConfiguration(loader: loader, cache: cache))
    }
}

/// Nuke's ImageTask extension to match the Disposable's action format
extension ImageTask {
    public func rac_cancel() {
        _ = self.cancel()
    }
}

// MARK: NukeAnimatedImagePlugin & FLAnimatedImage Extensions -

import FLAnimatedImage

extension FLAnimatedImageView {
    public var rac_animatedImage: MutableProperty<UIImage?> {
        return lazyMutableProperty(self, key: &AssociationKey.image, setter: { self.nk_displayImage($0) }, getter: { self.image })
    }
}
