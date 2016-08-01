//
//  CommonUserInterface.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/8/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import UIKit

// MARK: Common View Controller Appearance -

// Note: This is a direct mapping between plain parameters one might
// want to customize and their direct application to the "real" properties

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
    // In order to make everything work, this should be called in
    // -viewDidLayoutSubviews()
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

// MARK: Status Bar for Navigation Ctrl -

extension UINavigationController {
    public override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return self.topViewController
    }
    
    public override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.topViewController
    }
}

// MARK: Search Bar -

extension UISearchBar {
    class func giraffeSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true;
        searchBar.setImage(UIImage(named: "cancelsearch-normal"), forSearchBarIcon: UISearchBarIcon.Clear, state: UIControlState.Normal)
        searchBar.setImage(UIImage(named: "cancelsearch-highlighted"), forSearchBarIcon: UISearchBarIcon.Clear, state: UIControlState.Highlighted)
        searchBar.setImage(UIImage(named: "searchbar"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        searchBar.setImage(UIImage(named: "searchbar"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Highlighted)
        searchBar.tintColor = .giraffeOrange()
        searchBar.barTintColor = .giraffeOrange()
        return searchBar
    }
}

// MARK: Global Appearance -

// Should be called somewhere at application launch sequence (AppDelegate)
extension UIApplication {
    func applyGlobalAppearance() {
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = .giraffeOrange()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).backgroundColor = .giraffeWhite()
    }
}
