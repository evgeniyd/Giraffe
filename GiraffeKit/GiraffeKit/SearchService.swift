//
//  SearchService.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/6/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation

public struct Search: ServiceActionBodyTransformable {
    private let query: String // search query term or phrase
    private let parameters: Parameters?
    
    init(query: String, parameters: Parameters? = nil) {
        self.query = query
        self.parameters = parameters
    }
    
    func serviceActionBody() -> ServiceActionBody? {
        let escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        var actionBody = ["q": escapedQuery!]
        guard let _ = self.parameters else {
            return actionBody
        }
        guard let paramBody = self.parameters!.serviceActionBody() else {
            return actionBody
        }

        for key in paramBody.keys {
            actionBody[key] = paramBody[key]
        }
        return actionBody
    }
}

public struct SearchService: ServiceProtocol {
    public let actionPath = "search"
    public let actionBody: ServiceActionBody?
    
    public init(query: String, parameters: Parameters? = nil) {
        self.init(search: Search(query: query, parameters: parameters))
    }
    
    public init(search: Search) {
        actionBody = search.serviceActionBody()
    }
}

extension SearchService: ServiceRequestable {}
