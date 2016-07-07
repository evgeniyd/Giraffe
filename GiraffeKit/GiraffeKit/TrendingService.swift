//
//  TrendingService.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/6/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation

public struct TrendingService: ServiceProtocol {
    public var actionPath = "trending"
    public var actionBody: [String: String]? = nil
}

extension TrendingService: ServiceRequestable {}
