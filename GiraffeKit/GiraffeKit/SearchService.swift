//
//  SearchService.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/6/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation

public struct Search: ServiceActionBodyTransformable {
    private(set) var query: String // search query term or phrase
    private(set) var limit: Int? // (optional) number of results to return, maximum 100. Default 25.
    private(set) var offset: Int? // (optional) results offset, defaults to 0.
    private(set) var rating: Rating? // limit results to those rated (y,g, pg, pg-13 or r).
    // TODO: add fmt (fmt - (optional) return results in html or json format (useful for viewing responses as GIFs to debug/test) )
    
    init(query: String) {
        self.query = query
    }
    
    func serviceActionBody() -> ServiceActionBody {
        let escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let actionBody = ["q": escapedQuery!]
        return actionBody
    }
}

public struct SearchService: ServiceProtocol {
    public var actionPath = "search"
    public var actionBody: ServiceActionBody?
    
    
    public init(query: String) {
        self.init(search: Search(query: query))
    }
    
    public init(search: Search) {
        actionBody = search.serviceActionBody()
    }
}

extension SearchService: ServiceRequestable {}
