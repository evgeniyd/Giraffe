//
//  UIViewController+ViewType.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/16/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit
import ReactiveCocoa

extension ViewType where Self: UIViewController {
    func setupViewBindings() {
        let active = NSNotificationCenter.defaultCenter().rac_notifications(UIApplicationDidBecomeActiveNotification)
            .map { _ in
                return true
        }
        
        let inactive = NSNotificationCenter.defaultCenter().rac_notifications(UIApplicationWillResignActiveNotification)
            .map { _ in
                false
        }
        
        self.viewModel!.isActive <~ merge([active, inactive])
    }
}
