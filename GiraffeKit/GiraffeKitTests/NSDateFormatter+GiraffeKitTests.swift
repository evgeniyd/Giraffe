//
//  NSDateFormatter+GiraffeKitTests.swift
//  GiraffeKit
//
//  Created by Evgen Dubinin on 7/20/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import XCTest
@testable import GiraffeKit

class NSDateFormatter_GiraffeKitTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFormat() {
        let formatter = NSDateFormatter.giraffeDateFormatter()
        let testDate = formatter.dateFromString("2016-07-19 21:15:02")
        XCTAssert((testDate) != nil)
    }

}
