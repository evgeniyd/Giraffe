//
//  Error.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/18/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation

//////////////////
// Error
//////////////////
private let GiraffeErrorDomain = "com.devgeniy.GiraffeKit.Error"

public enum GiraffeError: ErrorType, CustomStringConvertible {
    case UnknownError
    case NetworkError
    case ParserError
    case LoadImageError(String)
    
    public var nsError: NSError {
        // TODO: add custom error code
        return NSError(domain: GiraffeErrorDomain, code: 0, userInfo: nil)
    }
    
    // MARK: - CustomStringConvertible -
    
    public var description: String {
        switch self {
        case .NetworkError:
            return "Network Error"
        case ParserError:
            return "Parser Error"
        case LoadImageError(let localizedDescription):
            return "Cannot load image. \(localizedDescription)"
        default:
            return "Unknown Error"
        }
    }
}
