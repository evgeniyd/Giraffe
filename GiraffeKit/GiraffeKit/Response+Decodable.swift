//
//  Response+Decodable.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/20/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import Unbox

////////////////////////////////////
// MARK: - Decodable extension -
////////////////////////////////////

// TODO: implement something like
// public static func decodedFrom(data data: NSData, response: NSURLResponse) -> SignalProducer<Response?, NSError>

extension Response: Decodable {
    // TODO: make this throw
    public static func decodedFrom(data data: NSData, response URLResponse: NSURLResponse) -> DecodingResult<Response, GiraffeError> {
        do {
            let response: Response = try Unbox(data)
            return .Success(response)
        } catch let unboxError as UnboxError {
            print("Unbox error during decoding: \(unboxError)")
            print(unboxError.description)
            // TODO: throw UnboxError
            return .Failure(GiraffeError.ParserError)
        } catch let unknownError {
            print("Unknown error during decoding: \(unknownError)")
            return .Failure(GiraffeError.ParserError)
        }
    }
}
