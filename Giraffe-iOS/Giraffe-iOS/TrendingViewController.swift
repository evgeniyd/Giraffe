//
//  ViewController.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/3/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result
import GiraffeKit

final class TrendingViewController: UIViewController, ViewType {
    
    enum TrendingVCSegue: SegueIdentifier {
        case embedCollectionVC
    }
    
    var viewModel                               = TrendingViewModel(model: Trending(service: TrendingService()))
    let searchBar                               = UISearchBar.giraffeSearchBar()
    var searchBarButtonItem: UIBarButtonItem?   = nil
    var collectionViewController: AnimatedImageCollectionViewController!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarButtonItem = navigationItem.rightBarButtonItem
        
        // Setup RAC bindings.
        setupBindings()
    }

    // MARK: - RAC Bindings
    
    func setupBindings() {
        // Setup view helper bindings.
        self.setupViewBindings()
        
        // Setup custom bindings.
        _ = viewModel.headline.producer.observeOn(UIScheduler()).startWithNext { next in
            self.navigationItem.title = next
        }
        messageLabel.rac_text <~ self.viewModel.message.producer.observeOn(UIScheduler())
        containerView.rac_hidden <~ self.viewModel.shouldHideTrending.producer.observeOn(UIScheduler())
        collectionViewController.rac_items <~ self.viewModel.items.producer.observeOn(UIScheduler())
    }

    // MARK: Search Bar Presentation
    
    private func showSearchBar() {
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        navigationItem.setRightBarButtonItem(nil, animated: false)
        UIView.animateWithDuration(0.5, animations: {
            self.searchBar.alpha = 1
            }, completion: { finished in
                self.searchBar.becomeFirstResponder()
        })
    }
    
    private func hideSearchBar() {
        navigationItem.setRightBarButtonItem(searchBarButtonItem, animated: true)
        UIView.animateWithDuration(0.3, animations: {
            self.navigationItem.title = self.viewModel.headline.value
            self.navigationItem.titleView = nil
            }, completion: { finished in
                
        })
    }
    
    // MARK: Storyboard
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // TODO: make more Swift-ty
        if (segue.identifier == TrendingVCSegue.embedCollectionVC.rawValue) {
            self.collectionViewController = segue.destinationViewController as! AnimatedImageCollectionViewController
        }
    }
    
    // MARK: Status Bar

    override func preferredStatusBarStyle() -> UIStatusBarStyle { return .LightContent }
    override func prefersStatusBarHidden() -> Bool { return false }
    
    // MARK: - Styling
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        applyCustomAppearance(DefaultViewControllerAppearance())
    }
    
    // MARK: Memmory Management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TrendingViewController: ViewControllerAppearanceCustomizable { }

