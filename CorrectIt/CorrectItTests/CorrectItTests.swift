//
//  CorrectItTests.swift
//  CorrectItTests
//
//  Created by Taillook on 2018/12/07.
//  Copyright © 2018 HimawariClass. All rights reserved.
//

import XCTest
@testable import CorrectIt

class CorrectItTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testColorOperation() {
        let CO = ColorOperation()
        print(CO.getColorDifference(rgb1: [255,255,255], rgb2: [245,253,250]))
    }

}
