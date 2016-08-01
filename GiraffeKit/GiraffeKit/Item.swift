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
// MARK: Main Model -
////////////////////////////////////
public struct Item {
    public var id: String
    public var type: ContentType
    public var rating: Rating
    public var trendingDate: NSDate?
    public var images: [Image]
    
    // MARK: FamilyFriendlyDetectable -
    
    public func isFamilyFriendly() -> Bool {
        return self.rating.isFamilyFriendly()
    }
}

////////////////////////////////////
// MARK: Supporting Models -
////////////////////////////////////

public enum ContentType: String {
    case gif
    case unknown
}

public enum Rating: String, CustomStringConvertible, FamilyFriendlyDetectable {
    // Source: https://www.quora.com/What-do-G-PG-PG-13-R-NC-17-movie-ratings-mean
    case y                  // ???
    case g                  // General Audiences. All ages admitted.
    case pg                 // Parental Guidance Suggested. Some material may not be suitable for children.
    case pg13 = "pg-13"     // Parents Strongly Cautioned. Some material may be inappropriate for children under 13.
    case r                  // Restricted. Under 17 requires accompanying parent or adult guardian.
    case unspecified = ""
    
    // MARK: FamilyFriendlyDetectable -
    
    public func isFamilyFriendly() -> Bool {
        //rated y,g, or pg
        switch self {
        case .y,.g,.pg:
            return true
        default:
            return false
        }
    }
    
    // MARK: CustomStringConvertible -
    
    public var description: String {
        get {
            return self.rawValue
        }
    }
}

public struct Image {
    public var variant: ImageVariant = .unknown
    public var url: NSURL
    public var width: CGFloat
    public var height: CGFloat
    
    // MARK: Convenience methods -
    
    public var size: CGSize {
        get { return CGSizeMake(self.width, self.height); }
    }
    
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
// MARK: Protocols -
////////////////////////////////////

public protocol FamilyFriendlyDetectable {
    func isFamilyFriendly() -> Bool
}

////////////////////////////////////
// MARK: Unboxable extension -
////////////////////////////////////

private struct Static {
    static let dateFormatter : NSDateFormatter = {
        let formatter = NSDateFormatter.giraffeDateFormatter()
        return formatter
    }()
}


extension Item: Unboxable {
    public init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.type = unboxer.unbox("type")
        self.rating = unboxer.unbox("rating")
        self.trendingDate = unboxer.unbox("trending_datetime", formatter: Static.dateFormatter)
        
        self.images = []
        
        // unboxing image variants
        
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
        self.width = unboxer.unbox("width")
        self.height = unboxer.unbox("height")
    }
}
