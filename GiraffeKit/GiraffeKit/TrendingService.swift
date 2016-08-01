//
//  TrendingService.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/6/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation

public struct TrendingService: ServiceProtocol {
    public let actionPath = "trending"
    public let actionBody: ServiceActionBody?
    public init() {
        actionBody = nil
    }
    public init(parameters: Parameters) {
        guard let body = parameters.serviceActionBody() where body.isEmpty == false else {
            actionBody = nil
            return;
        }
        actionBody = parameters.serviceActionBody()
    }
}

extension TrendingService: ServiceRequestable {}
