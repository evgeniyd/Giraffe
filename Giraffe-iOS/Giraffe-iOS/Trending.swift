//
//  Trending.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/16/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import GiraffeKit

// MARK: - Model Implementation -

final class Trending: Pageable {
    var page: Page?
    
    init() {
        // do nothing
    }
    
    // MARK: - Pageable -
    
    func nextPage() -> SignalProducer<Response?, GiraffeError> {
        let params = getNextPageParameters()
        let service = TrendingService(parameters: params)
        return invoke(service: service)
    }
}

extension Trending: Invokable { }
