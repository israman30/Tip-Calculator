//
//  TipCalcTests.swift
//  TipCalcTests
//
//  Created by Israel Manzo on 5/4/24.
//  Copyright © 2024 Israel Manzo. All rights reserved.
//

import XCTest
@testable import TipCalc

final class TipCalcTests: XCTestCase {
    
    var calculationsSUT: CalculationsViewModel!

    override func setUpWithError() throws {
        calculationsSUT = CalculationsViewModel()
    }

    override func tearDownWithError() throws {
        calculationsSUT = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
