//
//  UIColor+Giraffe.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/8/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit

extension UIColor {
    public class func giraffeYellow() -> UIColor {
        return UIColor(hexString: "#F1C40F")! 
    }
    
    public class func giraffeOrange() -> UIColor {
        return UIColor(hexString: "#E67E22")!
    }
    
    public class func giraffeWhite() -> UIColor {
        return UIColor.whiteColor() // just in case, the black would become a new white :)
    }
    
    public class func giraffeLightGray() -> UIColor {
        return UIColor(hexString: "#ededed")!
    }
}
