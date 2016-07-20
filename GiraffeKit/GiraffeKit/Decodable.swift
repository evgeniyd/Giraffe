//
//  Decodable.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/20/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation

public enum DecodingResult<ValueType,ErrorType> {
    case Error(ErrorType)
    case Value(ValueType)
}

public protocol Decodable {
    associatedtype Value
    associatedtype Error
    static func decodedFrom(data data: NSData, response: NSURLResponse) -> DecodingResult<Value,Error>
}
