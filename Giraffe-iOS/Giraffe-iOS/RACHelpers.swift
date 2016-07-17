//
//  RACHelpers.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/16/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import ReactiveCocoa
import Result

extension SignalProducer where Value: OptionalType {
    public func ignoreError() -> SignalProducer<Value, NoError> {
        return flatMapError { _ in
            SignalProducer<Value, NoError>.empty
        }
    }
}

public func merge<T, E>(signals: [SignalProducer<T, E>]) -> SignalProducer<T, E> {
    return SignalProducer<SignalProducer<T, E>, E>(values: signals).flatten(.Merge)
}
