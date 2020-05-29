//
//  mapAppTests.swift
//  mapAppTests
//
//  Created by user on 5/29/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import XCTest

@testable import mapApp

class mapAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModel(){
        let mainViewModel = MapsViewModel(mapsModelAccess: .MapBox)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
