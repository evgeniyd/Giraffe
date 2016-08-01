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
    
    private let model: Pageable
    private let response                = MutableProperty<Response?>(nil)
    private let items                   = MutableProperty<[Item]>([])
    // messages
    private let fetchErrorMsg           = "Something went wrong while getting trending"
    private let blankMsg                = ""
    private let emptyResponseMsg        = "No items were found"
    // images
    private let loadingImage            = UIImage(named: "GiraffeIsThinking")
    private let notFoundImage           = UIImage(named: "GiraffeIsDisappointed")
    
    // MARK: - ViewModelType -
    
    let isActive                    = MutableProperty<Bool>(false)
    let message                     = MutableProperty<String>("")
    let shouldHideItemsView         = MutableProperty<Bool>(true)
    let itemViewModels              = MutableProperty<[AnimatedImageViewModel]>([])
    let shouldDenoteTrending        = ConstantProperty<Bool>(false)
    let isLoading                   = MutableProperty<Bool>(false)
    let statusImage                 = MutableProperty<UIImage?>(nil)
    
    // MARK: - TrendingViewModelType -
    
    let headline                    = ConstantProperty<String?>("Trending")
    let searchText                  = MutableProperty<String>("")
    let searchResultViewModel       = MutableProperty<SearchResultViewModel?>(nil)
    let shouldEnableSearchButton    = MutableProperty<Bool>(false)
    
    let didScrollToBottom           = MutableProperty<Void>()
    
    // MARK: - Initialization -
    
    init(model: Pageable) {
        self.model = model
        
        // Setup RAC bindings.
        self.setupBindings()
    }
    
    func setupBindings() {
        
        self.isActive.producer
            .filter { $0 }
            .mapError { _ in
                return GiraffeError.UnknownError
            }.on(next: { _ in
                self.isLoading.value = true
                self.statusImage.value = self.loadingImage
            })
            .flatMap(.Latest) { _ in
                return self.model.nextPage()
            }
            .on(failed: { _ in
                    self.isLoading.value = false
                    self.message.value = self.fetchErrorMsg
                    self.statusImage.value = nil
                },
                next: { _ in
                    self.isLoading.value = false
                    self.statusImage.value = nil
                }
            )
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
            .map { response in
                var result = self.items.value
                result.appendContentsOf(response.data)
                return result
        }
        
        self.itemViewModels <~ self.items.producer.map { items in
            items.map { AnimatedImageViewModel(model: $0, denoteTrending: self.shouldDenoteTrending.value) }
        }
        
        let noItemsSignal = self.items.producer.map { items in
            items.count == 0
        }
        
        self.shouldHideItemsView <~ noItemsSignal
        self.statusImage <~ noItemsSignal.map { $0 ? self.notFoundImage : nil }
        
        self.searchText.producer
            .startWithResult { result in
                if let query: String = result.value {
                    let searchModel = SearchResult(query: query)
                    let searchResultViewModel = SearchResultViewModel(model: searchModel)
                    searchResultViewModel.headline.value = query
                    self.searchResultViewModel.value = searchResultViewModel
                }
        }
        
        self.shouldEnableSearchButton <~ self.isLoading.producer.map { !$0 }
        
        let loadNextPage = self.didScrollToBottom.producer
        loadNextPage
            // prevent from calling this at first place, before the first set is loaded
            // this is weird, but it works
            .filter {_ in self.items.value.count > 0 }
            .flatMap(.Latest) { _ in
                return self.model.nextPage()
            }
            // HACK: We'd like to receive an error and update the UI, but it well known
            // that SignalProducer stops upon failure, thus we have to retry it.
            // For now, retry as much as we can (Int.max times). There has to be more correct way to do this
            .retry(Constants.RetryAttempts)
            .startWithResult { result in
                self.response.value = result.value!
        }
    }
    
}
