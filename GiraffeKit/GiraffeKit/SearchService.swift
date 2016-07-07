//
//  SearchService.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/6/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation

public struct SearchService: ServiceProtocol {
    public var actionPath = "search"
    public var actionBody: [String: String]?
    
    public init(query: String) {
        let escapedQuery = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        actionBody = ["q": escapedQuery!]
    }
}

extension SearchService: ServiceRequestable {}
