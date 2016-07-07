//
//  ServiceTests.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/6/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import XCTest

class ServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTrendingService() {
        let service = TrendingService()
        let req = service.request()
        XCTAssertNotNil(req.URL)
        
        let testString = "https://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"
        XCTAssertTrue(req.URL!.absoluteString == testString)
    }
    
    func testSearchService() {
        let service = SearchService(query: "cat")
        let req = service.request()
        XCTAssertNotNil(req.URL)
        
        let testString = "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q=cat"
        XCTAssertTrue(req.URL!.absoluteString == testString)
    }
    
    func testSearchServiceCyrillic() {
        let service = SearchService(query: "кот")
        let req = service.request()
        XCTAssertNotNil(req.URL)
        
        let testString = "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q=%D0%BA%D0%BE%D1%82"
        XCTAssertTrue(req.URL!.absoluteString == testString)
    }
}
