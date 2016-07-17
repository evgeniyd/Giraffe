//
//  Data.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/7/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation

//////////////////
// Decoding
//////////////////
public enum DecodingResult<V> {
    case Error(ErrorType)
    case Value(V)
}

public protocol Decodable {
    associatedtype Value
    static func decodedFrom(data data: NSData, response: NSURLResponse) -> DecodingResult<Value>
}

//////////////////
// Meta
//////////////////
public enum DataType: String {
    case gif
}

public enum Rating: String {
    case y
    case g
    case pg
    case pg13 = "pg-13"
    case r
}

public struct MetaData {
    //var type: DataType
    var id: String
    //var rating: Rating
    //var trendingDate: NSDate
}
//////////////////
// Image
//////////////////

public enum ImageVariant {
    case fixedHeightSmall
    case fixedHeightSmallStill
    /*
    fixed_height
    fixed_height_still
    fixed_height_downsampled
     
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
}

public struct ImageData {
    var variant: ImageVariant
    var url: NSURL
    var size: CGSize
    var fileSize: UInt
}

//////////////////
// Item
//////////////////
public struct DataItem {
    var meta: MetaData
    //var images: [ImageData]?
}
//////////////////
// Response
//////////////////
public struct Page { }
public struct ResponseMeta { }

public struct Response {
    //var meta: ResponseMeta
    //var page: Page
    public var data: [DataItem]
}
//////////////////
// obtain different variants of image
//////////////////
protocol Framable {
    func singleFrame() -> ImageData
    func multipleFrame() -> ImageData
}
