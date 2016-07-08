//
//  ViewController.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/3/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit
import FLAnimatedImage
import ReactiveCocoa
import Result
import GiraffeKit

class TrendingViewController: UIViewController {
    
    let screenTitle = "Trending"
    
    var searchBar = UISearchBar()
    var searchBarButtonItem: UIBarButtonItem?
    var collectionViewController: AnimatedImageCollectionViewController!
    
    @IBOutlet weak var containerView: UIView!
    
    // Segue Identifiers
    enum TrendingVCSegue: SegueIdentifier {
        case embedCollectionVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Can replace logoImageView for titleLabel of navbar
        navigationItem.title = screenTitle
        searchBar.delegate = self
        searchBar.showsCancelButton = true;
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBarButtonItem = navigationItem.rightBarButtonItem
        
        let searchStrings = self.rac_signalForSelector(#selector(UISearchBarDelegate.searchBar(_:textDidChange:)), fromProtocol: UISearchBarDelegate.self)
            .toSignalProducer()
            .map { ($0 as? RACTuple)?.first as? UISearchBar }.ignoreNil()
            .map { $0.text }.ignoreNil()
            .throttle(5.0, onScheduler: QueueScheduler.mainQueueScheduler)
       
        // Making network requests
        let searchResults = searchStrings
            .filter{$0.characters.count >= 3}
            .flatMap(.Latest) { (query: String) -> SignalProducer<(NSData, NSURLResponse), NSError> in
                return NSURLSession.sharedSession()
                    .rac_dataWithRequest(SearchService(query: query).request())
                    .retry(2)
                    .flatMapError { error in
                        print("Network error occurred: \(error)")
                        return SignalProducer.empty
                }
            }
            .map { (data, URLResponse) -> DecodingResult<Response> in
                return Response.decodedFrom(data: data, response: URLResponse)
            }
            .observeOn(UIScheduler())
        
        searchResults.startWithNext { results in
            print("Search results: \(results)")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        self.searchField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Helpers
    
    private func showSearchBar() {
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        navigationItem.setRightBarButtonItem(nil, animated: true)
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
    
    private func testGIFsAnimation() {
        // remote
        let image = FLAnimatedImage.init(animatedGIFData: NSData(contentsOfURL: NSURL(string: "https://media1.giphy.com/media/l46CpUy7GwBmjP8QM/200.gif")!))
        let imageView = FLAnimatedImageView()
        imageView.animatedImage = image
        imageView.frame = CGRect(origin: CGPoint(x:0.0, y: 0.0), size: CGSize(width:  100.0, height: 100.0) )
        self.view.addSubview(imageView)
        
        // local
        let pathForFile = NSBundle.mainBundle().pathForResource("02", ofType: "gif")
        let url = NSURL.fileURLWithPath(pathForFile!)
        let data = NSData(contentsOfURL: url)
        let imageLocal = FLAnimatedImage.init(animatedGIFData: data)
        let imageViewLocal = FLAnimatedImageView()
        imageViewLocal.animatedImage = imageLocal
        imageViewLocal.frame = CGRect(origin: CGPoint(x:100.0, y: 0.0), size: CGSize(width:  100.0, height: 100.0) )
        self.view.addSubview(imageViewLocal)
    }
    
    // MARK: Storyboard
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // TODO: make more Swift-ty
        if (segue.identifier == TrendingVCSegue.embedCollectionVC.rawValue) {
            self.collectionViewController = segue.destinationViewController as! AnimatedImageCollectionViewController
        }
    }
    
    // MARK: Actions
    
    @IBAction func searchButtonDidPress(sender: AnyObject) {
        showSearchBar()
    }
}

extension TrendingViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        hideSearchBar()
    }
}

