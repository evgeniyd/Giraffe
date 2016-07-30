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

struct SearchResultViewModel: ViewModelType {
    
    private struct Constants {
        static let RetryAttempts: Int = Int.max
    }
    
    private let model: SearchResult
    private let response                = MutableProperty<Response?>(nil)
    private let items                   = MutableProperty<[Item]>([])
    private let isFamilyFriendlyActive  = MutableProperty<Bool>(true)
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
    var toggleFamilyFilter: RACCommand? = nil
    let shouldEnableFamilyFilterButton  = MutableProperty<Bool>(false)
    let shouldSelectFamilyFilterButton  = MutableProperty<Bool>(false)
    
    // MARK: - Initialization -
    
    init(model: SearchResult) {
        self.model = model
        
        // Setup RAC bindings.
        self.setupBindings()
    }
    
    // MARK: - RAC -
    
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
                return self.model.startPage()
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
                response.data
        }
        
        self.itemViewModels <~ self.items.producer.map { items in
            items.map { AnimatedImageViewModel(model: $0, denoteTrending: self.shouldDenoteTrending.value) }
        }
        
        let noItemsSignal = self.items.producer.map { items in
            items.count == 0
        }
        
        self.shouldHideItemsView <~ noItemsSignal
        self.statusImage <~ noItemsSignal.map { $0 ? self.notFoundImage : nil }
        self.shouldEnableFamilyFilterButton <~ self.isLoading.producer.map { !$0 }
        self.shouldSelectFamilyFilterButton <~ self.isFamilyFriendlyActive
    }
}

