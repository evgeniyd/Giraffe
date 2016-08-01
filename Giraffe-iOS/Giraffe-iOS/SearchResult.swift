//
//  SearchResult.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/24/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import GiraffeKit

// MARK: Model Implementation -

final class SearchResult: Pageable {
    private let query: String
    var page: Page?
    
    init(query q: String) {
        self.query = q
    }
    
    // MARK: Pageable -
    
    func nextPage() -> SignalProducer<Response?, GiraffeError> {
        let params = getNextPageParameters()
        let service = SearchService(query: self.query, parameters: params)
        
        return invoke(service: service)
    }
}

extension SearchResult: Invokable { }
