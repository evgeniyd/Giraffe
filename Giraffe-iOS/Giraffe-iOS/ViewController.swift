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

class ViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observing text edits
        let searchStrings = searchField.rac_textSignal()
            .toSignalProducer()
            .map { $0 as! String }
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
        self.searchField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}

