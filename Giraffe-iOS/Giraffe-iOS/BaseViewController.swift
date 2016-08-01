//
//  BaseViewController.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/25/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, ViewControllerAppearanceCustomizable {
    private let embededCollectionViewSegueIdentifier = "embedCollectionVC"
    private(set) var collectionViewController: AnimatedImageCollectionViewController!
    
    // MARK: View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBlankBackButtonTitle()
    }
    
    // MARK: Storyboard -
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == embededCollectionViewSegueIdentifier) {
            self.collectionViewController = segue.destinationViewController as! AnimatedImageCollectionViewController
        }
    }
    
    // MARK: Status Bar -
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle { return .LightContent }
    override func prefersStatusBarHidden() -> Bool { return false }
    
    // MARK: Memmory Management -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Styling -
    
    // hides "Back" button title (leaving only a shevron) for all VCs pushed by this VC
    private func setBlankBackButtonTitle() {
        if (isViewLoaded()) {
            let backItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    // MARK: Layout -
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        applyCustomAppearance(DefaultViewControllerAppearance())
    }
}
