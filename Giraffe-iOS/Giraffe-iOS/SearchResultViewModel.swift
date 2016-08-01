//
//  SearchResultViewModel.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/24/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result
import GiraffeKit

final class SearchResultViewModel: ViewModelType {
    
    private struct Constants {
        static let RetryAttempts: Int = Int.max
    }
    
    private let model                   : SearchResult
    private let response                = MutableProperty<Response?>(nil)
    private let items                   = MutableProperty<[Item]>([])
    private let isFamilyFilterActive    = MutableProperty<Bool>(false)
    private let isFamilyFilterEnable    = MutableProperty<Bool>(true)
    private let filteredItems           = MutableProperty<[Item]>([])
    
    // messages
    private let fetchErrorMsg           = "Something went wrong while getting trending"
    private let blankMsg                = ""
    private let emptyResponseMsg        = "No items were found"
    // images
    private let loadingImage            = UIImage(named: "GiraffeIsThinking")
    private let notFoundImage           = UIImage(named: "GiraffeIsDisappointed")

    // MARK: - ViewModelType -
    
    let isActive                        = MutableProperty<Bool>(false)
    let message                         = MutableProperty<String>("")
    let shouldHideItemsView             = MutableProperty<Bool>(true)
    let itemViewModels                  = MutableProperty<[AnimatedImageViewModel]>([])
    let shouldDenoteTrending            = ConstantProperty<Bool>(false)
    let isLoading                       = MutableProperty<Bool>(false)
    let statusImage                     = MutableProperty<UIImage?>(nil)
    
    // MARK: - ViewModel Public Properties -
    
    let headline                        = MutableProperty<String?>(nil)
    // TODO: make it const and Not Optional
    private(set) var toggleFamilyFilter : Action<Void,Void,NoError>?
    let shouldSelectFamilyFilterButton  = MutableProperty<Bool>(false)
    
    // MARK: - Initialization -
    
    init(model: SearchResult) {
        self.model = model

        shouldSelectFamilyFilterButton <~ isFamilyFilterActive
        isFamilyFilterEnable <~ isLoading.producer.map { !$0 }
        toggleFamilyFilter = Action<Void, Void, NoError>(enabledIf: isFamilyFilterEnable, { _ -> SignalProducer<Void, NoError> in
            return SignalProducer<Void, NoError> { [unowned self] observer, _ in
                self.isFamilyFilterActive.value = !self.isFamilyFilterActive.value
                observer.sendCompleted()
            }
        })
        
        self.isActive.producer
            .filter { $0 }
            .mapError { _ in
                return GiraffeError.UnknownError
            }.on(next: { [unowned self] _ in
                self.isLoading.value = true
                self.statusImage.value = self.loadingImage
            })
            .flatMap(.Latest) { [unowned self] _ in
                return self.model.nextPage()
            }
            .on(failed: { [unowned self] _ in
                self.isLoading.value = false
                self.message.value = self.fetchErrorMsg
                self.statusImage.value = nil
                },
                next: { [unowned self] _ in
                    self.isLoading.value = false
                    self.statusImage.value = nil
                }
            )
            // HACK: We'd like to receive an error and update the UI, but it well known
            // that SignalProducer stops upon failure, thus we have to retry it.
            // For now, retry as much as we can (Int.max times). There has to be more correct way to do this
            .retry(Constants.RetryAttempts)
            .startWithResult { [unowned self] result in
                self.response.value = result.value!
                self.message.value = self.response.value!.zeroItems ? self.emptyResponseMsg : self.blankMsg
        }
        
        self.items <~ self.response.producer
            .ignoreNil()
            .map { response in
                response.data
        }
        
        self.filteredItems <~ self.items.producer
            .map() { items in
                let filtered = items.filter{ $0.isFamilyFriendly() }
                return filtered
        }
        
        let updates = combineLatest(self.items.producer, self.filteredItems.producer, self.isFamilyFilterActive.producer)
        self.itemViewModels <~ updates.producer.map { items, filteredItems, filter in
            if filter {
                return filteredItems.map { AnimatedImageViewModel(model: $0, denoteTrending: self.shouldDenoteTrending.value) }
            }
            else {
                return items.map { AnimatedImageViewModel(model: $0, denoteTrending: self.shouldDenoteTrending.value) }
            }
        }
        
        let noItemsSignal = self.items.producer.map { $0.count == 0 }
        self.shouldHideItemsView <~ noItemsSignal
        self.statusImage <~ noItemsSignal.map { $0 ? self.notFoundImage : nil }
    }
}

