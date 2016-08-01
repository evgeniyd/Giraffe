//
//  NSDateFormatter+GiraffeKit.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/20/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    static func giraffeDateFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }
}
