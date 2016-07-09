//
//  CommonUserInterface.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/8/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import UIKit

// Semantic data type
typealias SegueIdentifier = String

// MARK: Common View Controller Appearance

protocol ViewControllerAppearance {
    var navigationBarBackgroundColor: UIColor { get }
    var navigationBarTitleColor: UIColor { get }
    var navigationBarButtonsColor: UIColor { get }
    var navigationBarTitleFont: UIFont { get }
}

struct DefaultViewControllerAppearance: ViewControllerAppearance {
    var navigationBarBackgroundColor = UIColor.giraffeYellow()
    var navigationBarTitleColor = UIColor.giraffeWhite()
    var navigationBarTitleFont = UIFont.giraffeScreenTitleFont()
    var navigationBarButtonsColor = UIColor.giraffeOrange()
}

protocol ViewControllerAppearanceCustomizable {
    /// call the method in viewDidLoad:
    func applyCustomAppearance(appearance: ViewControllerAppearance)
}

extension ViewControllerAppearanceCustomizable where Self: UIViewController {
    func applyCustomAppearance(appearance: ViewControllerAppearance) {
        self.navigationController?.navigationBar.tintColor = appearance.navigationBarButtonsColor
        self.navigationController?.navigationBar.barTintColor = appearance.navigationBarBackgroundColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : appearance.navigationBarTitleColor,
                                                                        NSFontAttributeName : appearance.navigationBarTitleFont]
        self.navigationController?.navigationBar.translucent = false
    }
}

// MARK: Status Bar for Navigation Ctrl

extension UINavigationController {
    public override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return self.topViewController
    }
    
    public override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.topViewController
    }
}

// MARK: Search Bar

extension UISearchBar {
    class func giraffeSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true;
//        self.searchBar.setImage(UIImage(named: "ico-cancel"), forSearchBarIcon: UISearchBarIcon.Clear, state: UIControlState.Normal)
//        self.searchBar.setImage(UIImage(named: "ico-cancel"), forSearchBarIcon: UISearchBarIcon.Clear, state: UIControlState.Highlighted)
//        self.searchBar.setImage(UIImage(named: "ico-cancel"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
//        self.searchBar.setImage(UIImage(named: "ico-cancel"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Highlighted)
        return searchBar
    }
}

// MARK: Global Appearance

extension UIApplication {
    func applyGlobalAppearance() {
        UISearchBar.appearance().barTintColor = UIColor.giraffeYellow()
        UISearchBar.appearance().tintColor = UIColor.giraffeOrange()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = UIColor.giraffeOrange()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).backgroundColor = UIColor.giraffeWhite()
    }
}
