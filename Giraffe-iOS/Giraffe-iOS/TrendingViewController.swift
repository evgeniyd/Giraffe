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

public protocol TrendingModelType {
    var searchMode: Bool { get set }
//    func whatsTrending() -> /*SignalProducer<DecodingResult<Response>, NSError> */SignalProducer<(NSData, NSURLResponse), NSError>
}

public class TrendingModel: TrendingModelType {
    public var searchMode: Bool = false
    let service: TrendingService
    public init(service s: TrendingService) {
        self.service = s
    }
    
//    public func whatsTrending() -> /*SignalProducer<DecodingResult<Response>, NSError> */SignalProducer<(NSData, NSURLResponse), NSError>{
//        
//        return NSURLSession.sharedSession()
//            .rac_dataWithRequest(self.service.request())
//            .retry(2)
//            .flatMapError { error in
//                print("Network error occurred: \(error)")
//                return SignalProducer.empty
//        } // SignalProducer<(NSData, NSURLResponse), NSError>
//        
//        
////        .map { (data, URLResponse) -> DecodingResult<Response> in
////            return Response.decodedFrom(data: data, response: URLResponse)
////        }
////            .map { (data, NSURLResponse) -> SignalProducer<DecodingResult<Response>, NSError> in
////                let (producer, observer) = SignalProducer<DecodingResult<Response>, NoError>.buffer(1)
////                observer.sendNext(Response.decodedFrom(data: data, response: URLResponse))
////                return (producer, observer)
////            }
//    }
}

public protocol TrendingViewModelType {
    var isSearchMode: MutableProperty<Bool> { get }
    var toggleSearchMode: Action<Void, Void, NSError>! { get }
}

public struct TrendingViewModel: TrendingViewModelType {
    private let model: TrendingModelType
    
    public let isSearchMode: MutableProperty<Bool> = MutableProperty(false)
    public var toggleSearchMode: Action<Void, Void, NSError>!
    
    public init(model: TrendingModelType) {
        self.model = model
        
//        toggleSearchMode = Action<Void, Void, NSError>(enabledIf: isSearchMode) { _ -> SignalProducer<Void, NSError> in
//            print("")
//            return
//        }
    }
}

final class TrendingViewController: UIViewController {
    
    var viewModel = TrendingViewModel(model: TrendingModel(service: TrendingService()))
    
    var screenTitle = "Trending"
    
    let searchBar = UISearchBar.giraffeSearchBar()
    var searchBarButtonItem: UIBarButtonItem?
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    var collectionViewController: AnimatedImageCollectionViewController!
    
    @IBOutlet weak var containerView: UIView!
    
    // Segue Identifiers
    enum TrendingVCSegue: SegueIdentifier {
        case embedCollectionVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.applyCustomAppearance(DefaultViewControllerAppearance())
        
        searchBarButtonItem = navigationItem.rightBarButtonItem
        
        navigationItem.title = screenTitle

//        searchBarButtonItem?.rac_command = viewModel.toggleSearchCommand
        //searchBarButtonItem.rac_enabled <~ viewModel.isSearchMode.producer.takeUntil(rac_willDeallocSignal())
        
        
//        let action = Action<UIBarButtonItem, Void, NoError> { value in
//            return SignalProducer<Void, NoError> { observer, _ in
//                print("HEllo")
//            }
//        }
//        
//        searchButtonAction = CocoaAction(action, { value in
//            let barButtonItem = value as! UIBarButtonItem
//            return barButtonItem
//        })
//        
//        searchButton.addTarget(searchButtonAction,
//                               action: CocoaAction.selector,
//                               forControlEvents: UIControlEvents.TouchUpInside)
        
//        let asignal: Signal<String, NoError>
//        self.screenTitle <~ asignal
//        asignal.start { next in
//            print(value)
//        }
//        let searchButton = self.rac_signalForSelector(#selector(UISearchBarDelegate.searchBarCancelButtonClicked(_:)), fromProtocol: UISearchBarDelegate.self)
////            .toSignalProducer()
////            .observeNext { next in
////                print("Next: \(next)")
////            }
//            searchButton.observe(Signal.Observer { event in
//                switch event {
//                case let .Next(next):
//                    print("Next: \(next)")
//                case let .Failed(error):
//                    print("Failed: \(error)")
//                case .Completed:
//                    print("Completed")
//                case .Interrupted:
//                    print("Interrupted")
//                }
//                })
        
        // RAC
        // Signal setup
//        let searchStrings = self.rac_signalForSelector(#selector(UISearchBarDelegate.searchBar(_:textDidChange:)), fromProtocol: UISearchBarDelegate.self)
//            .toSignalProducer()
//            .map { ($0 as? RACTuple)?.first as? UISearchBar }.ignoreNil()
//            .map { $0.text }.ignoreNil()
//            .throttle(1.0, onScheduler: QueueScheduler.mainQueueScheduler)
//       
//        // Observer setup
//        let searchResults = searchStrings
//            .filter{$0.characters.count >= 3}
//            .flatMap(.Latest) { (query: String) -> SignalProducer<(NSData, NSURLResponse), NSError> in
//                return NSURLSession.sharedSession()
//                    .rac_dataWithRequest(SearchService(query: query).request())
//                    .retry(2)
//                    .flatMapError { error in
//                        print("Network error occurred: \(error)")
//                        return SignalProducer.empty
//                }
//            }
//            .map { (data, URLResponse) -> DecodingResult<Response> in
//                return Response.decodedFrom(data: data, response: URLResponse)
//            }
//            .observeOn(UIScheduler())
//        
//        searchResults.startWithResult { results in
//            print("Search results: \(results)")
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Helpers
    
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
            self.navigationItem.title = self.screenTitle
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}

extension TrendingViewController: ViewControllerAppearanceCustomizable { }

