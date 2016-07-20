//
//  Framable.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/20/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation

/// The protocol helps to incapsulate the image data variant
/// required by current framework user
protocol Framable {
    func singleFrame() -> Image
    func multiFrame() -> Image
}

/// Default implementation

extension Item: Framable {
    func singleFrame() -> Image {
        return self.images
            .indexOf { $0.variant == ImageVariant.fixedHeightStill }
            .map { self.images[$0]}!
    }
    
    func multiFrame() -> Image {
        return self.images
            .indexOf { $0.variant == ImageVariant.fixedHeight }
            .map { self.images[$0]}!
    }
}
