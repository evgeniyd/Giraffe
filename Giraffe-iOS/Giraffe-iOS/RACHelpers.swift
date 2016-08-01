//
//  RACHelpers.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/16/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import ReactiveCocoa
import Result

// SignalProducer<Value, ErrorType> -> SignalProducer<Value, NoError>
extension SignalProducer where Value: OptionalType {
    public func ignoreError() -> SignalProducer<Value, NoError> {
        return flatMapError { _ in
            SignalProducer<Value, NoError>.empty
        }
    }
}

// Merge a collection of SignalProducer's
public func merge<T, E>(signals: [SignalProducer<T, E>]) -> SignalProducer<T, E> {
    return SignalProducer<SignalProducer<T, E>, E>(values: signals).flatten(.Merge)
}


extension Signal {
    // Merget two Signal's
    public static func merge<S: SequenceType where S.Generator.Element == Signal<Value, Error>>(signals: S) -> Signal<Value, Error> {
        let producer = SignalProducer<Signal<Value, Error>, Error>(values: signals)
        var result: Signal<Value, Error>!
        
        producer.startWithSignal { (signal, _) in
            result = signal.flatten(.Merge)
        }
        
        return result
    }
}
