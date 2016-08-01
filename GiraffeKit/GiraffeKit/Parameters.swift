//
//  Parameters.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/31/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation

public struct Parameters: ServiceActionBodyTransformable {
    public let limit: Int? // (optional) number of results to return, maximum 100. Default 25.
    public let offset: Int? // (optional) results offset, defaults to 0.
    public let rating: Rating? // limit results to those rated (y,g, pg, pg-13 or r).
    // TODO: add fmt (fmt - (optional) return results in html or json format (useful for viewing responses as GIFs to debug/test) )
    
    public init(limit: Int? = nil, offset: Int? = nil, rating: Rating? = nil) {
        self.limit = limit
        self.offset = offset
        self.rating = rating
    }
    
    // MARK: ServiceActionBodyTransformable -
    
    func serviceActionBody() -> ServiceActionBody? {
        var result: ServiceActionBody = [:]
        if let _ = limit { result["limit"] = limit!.description }
        if let _ = offset { result["offset"] = offset!.description }
        if let _ = rating { result["rating"] = rating!.description }
        return result.isEmpty ? nil : result // convert empty to nil
    }
}
