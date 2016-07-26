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
    
    private struct Constants {
        static let RetryAttempts: Int = Int.max
    }
    
    private let model: TrendingModelType
    private let response                = MutableProperty<Response?>(nil)
    private let items                   = MutableProperty<[Item]>([])
    private let fetchErrorMsg           = "Something went wrong while getting trending"
    private let blankMsg                = ""
    private let emptyResponseMsg        = "No items were found"
    
    // MARK: - ViewModelType -
    
    let isActive                    = MutableProperty<Bool>(false)
    let message                     = MutableProperty<String>("")
    let shouldHideItemsView         = MutableProperty<Bool>(true)
    let itemViewModels              = MutableProperty<[AnimatedImageViewModel]>([])
    
    // MARK: - TrendingViewModelType -
    
    let headline                    = ConstantProperty<String?>("Trending")
    let searchText                  = MutableProperty<String>("")
    let searchResultViewModel       = MutableProperty<SearchResultViewModel?>(nil)
    
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
                self.message.value = self.fetchErrorMsg
            })
            // HACK: We'd like to receive an error and update the UI, but it well known
            // that SignalProducer stops upon failure, thus we have to retry it.
            // For now, retry as much as we can (Int.max times). There has to be more correct way to do this
            .retry(Constants.RetryAttempts)
            .startWithResult { result in
                self.response.value = result.value!
                self.message.value = self.response.value!.zeroItems ? self.emptyResponseMsg : self.blankMsg
        }
        
        self.items <~ self.response.producer
            .ignoreNil()
            .map { response in response.data }
        
        self.itemViewModels <~ self.items.producer.map { items in
            items.map{ AnimatedImageViewModel(model: $0) }
        }
        
        // Make sure, we're only showing the trending view if there are actually some results
        self.shouldHideItemsView <~ self.items.producer.map { items in
            items.count == 0
        }
        
        self.searchText.producer
            .startWithResult { result in
                if let query: String = result.value {
                    let service = SearchService(query: query)
                    let searchModel = SearchResult(service: service)
                    let searchResultViewModel = SearchResultViewModel(model: searchModel)
                    searchResultViewModel.headline.value = query
                    self.searchResultViewModel.value = searchResultViewModel
                }
        }
    }
    
}
