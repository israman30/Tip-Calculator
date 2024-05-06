//
//  CurrencyStringExtensionTest.swift
//  TipCalcTests
//
//  Created by Israel Manzo on 5/4/24.
//  Copyright © 2024 Israel Manzo. All rights reserved.
//

import XCTest
import UIKit
@testable import TipCalc

final class CurrencyStringExtensionTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_CurrencyInput_Formatting() {
        // Given
        let testCases: [(input: String, expectedOutput: String)] = [
            ("100", "$1.00"),
            ("1000", "$10.00"),
            ("10000", "$100.00"),
            ("123456", "$1,234.56"),
            ("987654", "$9,876.54"),
            ("123.45", "$1.23"),
            ("987.65", "$9.88"),
            ("abc123", "$1.23"),
            ("1a2b3c", "$1.23"),
            ("", "")
        ]
        
        // When
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        for testCase in testCases {
            let result = testCase.input.currencyInputFormatting()
            let expectedResult = formatter.string(from: NSNumber(value: (Double(testCase.input) ?? 0) / 100)) ?? ""
            
            // Then
            XCTAssertNotEqual("$\(result)", expectedResult, "Formatted result should match expected result")
        }
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
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
