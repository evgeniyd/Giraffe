//
//  Response.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/20/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import Unbox

////////////////////////////////////
// MARK: Model -
////////////////////////////////////

public struct Meta {
    public var status: Int
    public var message: String
}

public struct Page {
    public var totalCount: Int?
    public var count: Int
    public var offset: Int
    
    // MARK: Convinient Methods -
    
    public func hasNextPage() -> Bool {
        guard let total = totalCount else { return true } // no limit
        let index = indexOfFirstElementOnNextPage()
        return (index > total) ? false : true
    }
    
    public func indexOfFirstElementOnNextPage() -> Int {
        return offset + count
    }
}

public struct Response {
    public var data: [Item]
    public var meta: Meta
    public var pagination: Page
}

////////////////////////////////////
// MARK: Convenience methods -
////////////////////////////////////

extension Response {
    public var zeroItems: Bool {
        get {
            return (self.data.count == 0)
        }
    }
}

////////////////////////////////////
// MARK: Unboxable extension -
////////////////////////////////////

extension Meta: Unboxable {
    public init(unboxer: Unboxer) {
        self.status = unboxer.unbox("status")
        self.message = unboxer.unbox("msg")
    }
}

extension Page: Unboxable {
    public init(unboxer: Unboxer) {
        self.count = unboxer.unbox("count")
        self.offset = unboxer.unbox("offset")
        self.totalCount = unboxer.unbox("total_count")
    }
}

extension Response: Unboxable {
    public init(unboxer: Unboxer) {
        self.data = unboxer.unbox("data")
        self.meta = unboxer.unbox("meta")
        self.pagination = unboxer.unbox("pagination")
    }
    
}
