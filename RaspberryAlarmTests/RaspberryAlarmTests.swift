//
//  RaspberryAlarmTests.swift
//  RaspberryAlarmTests
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import XCTest
@testable import RaspberryAlarm

class RaspberryAlarmTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMerging() {
        XCTAssert(1 + 1 == 2)
        XCTAssert(2 + 2 == 4)
        XCTAssert("Hello" + "World" == "HelloWorld")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
