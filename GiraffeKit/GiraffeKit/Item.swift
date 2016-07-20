//
//  Item.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/20/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import Unbox
import CoreGraphics

////////////////////////////////////
// MARK: - Main Model -
////////////////////////////////////
public struct Item {
    public var id: String
    public var type: ContentType
    public var rating: Rating
    public var trendingDate: NSDate?
    public var images: [Image]
    
    // MARK: - Convenience methods -
    
    func isEverTrended() -> Bool {
        return (self.trendingDate != nil)
    }
}

////////////////////////////////////
// MARK: - Supporting Models -
////////////////////////////////////

public enum ContentType: String {
    case gif
    case unknown
}

public enum Rating: String {
    case y
    case g
    case pg
    case pg13 = "pg-13"
    case r
    case unspecified
}

public struct Image {
    var variant: ImageVariant = .unknown
    var url: NSURL
    TODO: transform this
//    var size: CGSize
//    var fileSize: UInt
    
    mutating func specify(variant newVariant: ImageVariant) {
        self.variant = newVariant
    }
}

public enum ImageVariant {
    case fixedHeight
    case fixedHeightStill
    /*
    fixed_height_downsampled
    
    case fixedHeightSmall
    case fixedHeightSmallStill
     
     fixed_width
     fixed_width_still
     fixed_width_downsampled
     
     fixed_height_small
     fixed_height_small_still
     
     fixed_width_small
     fixed_width_small_still
     
     downsized
     downsized_still
     downsized_large
     downsized_medium
     
     original
     original_still
     
     looping
     */
    
    case unknown
}

////////////////////////////////////
// MARK: - Unboxable extension -
////////////////////////////////////

private let dateFormatter = NSDateFormatter.giraffeDateFormatter()

extension Item: Unboxable {
    public init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.type = unboxer.unbox("type")
        self.rating = unboxer.unbox("rating")
        self.trendingDate = unboxer.unbox("trending_datetime", formatter: dateFormatter)
        
        self.images = []
        
        var fixedHeightImage: Image  = unboxer.unbox("images.fixed_height", isKeyPath: true)
        fixedHeightImage.specify(variant: .fixedHeight)
        self.images.append(fixedHeightImage)
        
        var fixedHeightStill: Image  = unboxer.unbox("images.fixed_height_still", isKeyPath: true)
        fixedHeightStill.specify(variant: .fixedHeightStill)
        self.images.append(fixedHeightStill)
    }
}

extension ContentType: UnboxableEnum {
    public static func unboxFallbackValue() -> ContentType {
        return .unknown
    }
}

extension Rating: UnboxableEnum {
    public static func unboxFallbackValue() -> Rating {
        return .unspecified
    }
}

extension Image: Unboxable {
    public init(unboxer: Unboxer) {
        self.url = unboxer.unbox("url")
        self.variant = .unknown
    }
}
