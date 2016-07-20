//
//  TrendingViewModel.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/16/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import GiraffeKit

// MARK: ViewModel Protocol

protocol TrendingViewModelType: ViewModelType {
    var headline: ConstantProperty<String> { get }
}

struct TrendingViewModel: TrendingViewModelType {
    private let model: TrendingModelType
    private let fetchTrendingErrorMsg   = "Something went wrong while getting trending."
    private let emptyMsg = ""
    
    let headline                    = ConstantProperty<String>("Trending")
    let isActive                    = MutableProperty<Bool>(false)
    let message                     = MutableProperty("")
    private let trendingResponse    = MutableProperty<Response?>(nil)
    let items                       = MutableProperty<[Item]>([])
    let shouldHideTrending          = MutableProperty<Bool>(true)
    
    init(model: TrendingModelType) {
        self.model = model
        
        // Setup RAC bindings.
        self.setupBindings()
    }
    
    func setupBindings() {
        
        self.isActive.producer
            .filter { $0 }
            .mapError { _ in
                return GiraffeError.UnknownError
            }
            .flatMap(.Latest) { _ in
                return self.model.whatsTrending()
            }
            .on(failed: { _ in
                self.message.value = self.fetchTrendingErrorMsg
            })
            // HACK: We'd like to receive an error and update the UI, but it well known
            // that SignalProducer stops upon failure, thus we have to retry it.
            // For now, retry as much as we can (Int.max times). There has to be more correct way to do this
            .retry(Int.max)
            .startWithResult { result in
                self.trendingResponse.value = result.value!
                self.message.value = self.emptyMsg
        }
        
        self.items <~ self.trendingResponse.producer
            .ignoreNil()
            .map { response in
                response.data
        }
        
        // Make sure, we're only showing the trending view if there are actually some results
        self.shouldHideTrending <~ self.items.producer.map { items in
            items.count == 0
        }
    }
}
