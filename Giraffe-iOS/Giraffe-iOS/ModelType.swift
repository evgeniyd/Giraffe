//
//  ModelType.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/31/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import GiraffeKit

// MARK: - Model Constant -

struct ServiceConstanst {
    static let itemsPerPage = 26
    static let retryAttempts = 3
}

// MARK: - Model Page Protocol -

protocol Pageable {
    var page: Page? { get set }
    func hasNextPage() -> Bool
    func nextPage() -> SignalProducer<Response?, GiraffeError>
}

extension Pageable {
    func hasNextPage() -> Bool {
        if let _ = self.page {
            return true
        }
        return self.page!.hasNextPage()
    }
}

// MARK: - Parameters Extension -

extension Pageable {
    func getNextPageParameters() -> Parameters {
        guard let previousPageInfo = self.page else {
            return Parameters(limit: ServiceConstanst.itemsPerPage)
        }
        
        let limit = ServiceConstanst.itemsPerPage
        // TODO: throws when previousPageInfo.hasNextPage() == false
        let offset = previousPageInfo.indexOfFirstElementOnNextPage()
        
        return Parameters(limit: limit, offset: offset)
    }
}

// MARK: - Invokable Protocol -

protocol Invokable: class {
    func invoke(service s: ServiceRequestable) -> SignalProducer<Response?, GiraffeError>
}

extension Invokable where Self: Pageable {
    func invoke(service s: ServiceRequestable) -> SignalProducer<Response?, GiraffeError> {
        let session = NSURLSession.sharedSession()
        let request = s.request()
        
        return session.rac_dataWithRequest(request)
            .retry(ServiceConstanst.retryAttempts)
            .mapError{ _ in
                return GiraffeError.NetworkError
            }
            .flatMapError { networkError in
                print(networkError)
                return SignalProducer(error: networkError)
            }
            .map { [weak self] data, URLResponse in
                // TODO: #1 make this reactive, so
                switch Response.decodedFrom(data: data, response: URLResponse) {
                case .Failure(let decodeError):
                    print("Parsing error occurred. Error was:\n\(decodeError)")
                    // TODO: #2 we can do the following:
                    //                    return SignalProducer(error: GiraffeError.ParserError)
                    return nil
                case .Success(let result):
                    self?.page = result.pagination
                    return result
                }
        }
    }
}
