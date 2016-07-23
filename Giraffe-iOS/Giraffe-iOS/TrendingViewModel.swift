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


// TODO: I'd be happy to create something like this:
//
// protocol TrendingViewModelType: ViewModelType { 
//     /* interface used by a view */
// }
//
// However, sadly, Swift cannot infer 
// 'associatedtype VM: ViewModelType' from ViewType protocol
// when TrendingViewModelType type is specified for 
// 'var viewModel: TrendingViewModelType?' requirement
// We are forced to use concrete type when conforming to ViewType protocol
// More Info : http://stackoverflow.com/questions/37360114/unable-to-use-protocol-as-associatedtype-in-another-protocol-in-swift/37360351#37360351


// MARK: - ViewModel Protocol -

struct TrendingViewModel: ViewModelType {
    private let model: TrendingModelType
    private let fetchTrendingErrorMsg   = "Something went wrong while getting trending."
    private let emptyMsg = ""
    private let trendingResponse    = MutableProperty<Response?>(nil)
    
    // MARK: - ViewModelType -
    
    let isActive                    = MutableProperty<Bool>(false)
    
    // MARK: - TrendingViewModelType -
    
    let headline                    = ConstantProperty<String>("Trending")
    let message                     = MutableProperty("")
    let items                       = MutableProperty<[Item]>([])
    let shouldHideTrending          = MutableProperty<Bool>(true)
    
    // MARK: - Initialization -
    
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
                return self.model.startPage()
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
