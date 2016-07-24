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

// MARK: - Model Implementation -

final class SearchResult {
    private let service: SearchService
    
    init(service s: SearchService) {
        self.service = s
    }
    
    func startPage() -> SignalProducer<Response?, GiraffeError> {
        let session = NSURLSession.sharedSession()
        let request = self.service.request()
        let retryAttempts = 3
        
        return session.rac_dataWithRequest(request)
            .retry(retryAttempts)
            .mapError{ _ in
                return GiraffeError.NetworkError
            }
            .flatMapError { networkError in
                print(networkError)
                return SignalProducer(error: networkError)
            }
            .map { data, URLResponse in
                // TODO: #1 make this reactive, so
                switch Response.decodedFrom(data: data, response: URLResponse) {
                case .Failure(let decodeError):
                    print("Parsing error occurred. Error was:\n\(decodeError)")
                    // TODO: #2 we can do the following:
                    //                    return SignalProducer(error: GiraffeError.ParserError)
                    return nil
                case .Success(let result):
                    return result
                }
        }
    }
}
