//
//  UIFont+Giraffe.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/8/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation


import UIKit

extension UIFont {
    class func giraffeScreenTitleFont() -> UIFont {
        return UIFont.giraffeScreenTitleFont(ofSize: 20.0)
    }
    
    class func giraffeScreenTitleFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFontOfSize(fontSize, weight: UIFontWeightMedium)
    }
}

