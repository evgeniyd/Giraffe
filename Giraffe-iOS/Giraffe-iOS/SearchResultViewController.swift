//
//  SearchResultViewController.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/24/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result
import GiraffeKit

final class SearchResultViewController: BaseViewController {

    private var viewModel: SearchResultViewModel? = nil
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup RAC bindings.
        setupBindings()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.isActive.value = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel?.isActive.value = false
        
    }
    
    // MARK: - RAC -
    
    func bindWith(viewModel vm: SearchResultViewModel) {
        self.viewModel = vm
    }
    
    private func setupBindings() {
        // Setup custom bindings.
        navigationItem.rac_title <~ viewModel!.headline.producer.observeOn(UIScheduler())
        collectionViewController.rac_items <~ viewModel!.items.producer.observeOn(UIScheduler())
        messageLabel.rac_text <~ viewModel!.message.producer.observeOn(UIScheduler())
        containerView.rac_hidden <~ viewModel!.shouldHideItemsView.producer.observeOn(UIScheduler())
    }
}


