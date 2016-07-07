//
//  Service.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/6/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation

public enum TransferProtocol: String {
    case http, https
}

public protocol ServiceProtocol {
    var transferProtocol: TransferProtocol { get }
    var basePath: String { get }
    var apiKey: String { get }
    var actionPath: String { get }
    var actionBody: [String: String]? { get }
}

public protocol ServiceRequestable {
    // TODO: actionMethod() -> ServiceActionMethod - YAGNI
    func request() -> NSURLRequest
}

// Default implementations

extension ServiceProtocol {
    public var transferProtocol: TransferProtocol {
        get { return .https }
    }
    
    public var basePath: String {
        get { return "api.giphy.com/v1/gifs/" }
    }
    
    public var apiKey: String {
        get { return "dc6zaTOxFJmzC" }
    }
    
    public var actionPath: String {
        get { return "" }
    }
    
    public var actionBody: [String: String]? {
        get { return nil }
    }
}

extension ServiceRequestable where Self: ServiceProtocol {
    public func request() -> NSURLRequest {
        var requestPath: String = "\(self.transferProtocol)://" + basePath + actionPath
        requestPath += "?api_key=\(apiKey)"
        if let actionBody = self.actionBody {
            for (paramKey, paramValue) in actionBody {
                requestPath.appendContentsOf("&\(paramKey)=\(paramValue)")
            }
        }
        return NSURLRequest(URL: NSURL(string: requestPath)!)
    }
}
