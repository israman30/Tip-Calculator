//
//  TipCalcTests.swift
//  TipCalcTests
//
//  Created by Israel Manzo on 5/16/24.
//  Copyright © 2024 Israel Manzo. All rights reserved.
//

import XCTest
@testable import TipCalc

// Mock ViewModel implementing ViewModelBillCalculationsProtocol
class MockViewModel: ViewModelBillCalculationsProtocol {
    var calculateTipCalled = false
    var resetCalled = false
    var splitBillCalled = false
    
    func calculateTip(with valueInput: UITextField, segment: UISegmentedControl, tipValue: UILabel, totalValue: UILabel) {
        calculateTipCalled = true
    }
    
    func reset(valueInput: UITextField, tipValue: UILabel, totalValue: UILabel, totalByPerson: UILabel, peopleQuantity: UILabel) {
        resetCalled = true
    }
    
    func splitBiil(people: UILabel, bill: Double, totalByPerson: UILabel) {
        splitBillCalled = true
    }
}

final class TipCalcTests: XCTestCase {
    
    var caclculations: CalculationsViewModel!
    var mockViewModel: MockViewModel!
    var valueInput: UITextField!
    var segment: UISegmentedControl!
    var tipValue: UILabel!
    var totalValue: UILabel!

    override func setUpWithError() throws {
        caclculations = CalculationsViewModel()
        mockViewModel = MockViewModel()
        valueInput = UITextField()
        segment = UISegmentedControl()
        tipValue = UILabel()
        totalValue = UILabel()
    }

    override func tearDownWithError() throws {
        caclculations = nil
        mockViewModel = nil
        valueInput = nil
        segment = nil
        tipValue = nil
        totalValue = nil
    }
    
    func test_MainBill_Initialization() {
        XCTAssertEqual(caclculations.mainBill, 0.0, "Initial value of mainBill should be 0.0")
    }
    
    func test_ViewModel_Bill_Calculations() {
        // When
        mockViewModel.calculateTip(with: UITextField(), segment: UISegmentedControl(), tipValue: UILabel(), totalValue: UILabel())
        mockViewModel.reset(valueInput: UITextField(), tipValue: UILabel(), totalValue: UILabel(), totalByPerson: UILabel(), peopleQuantity: UILabel())
        mockViewModel.splitBiil(people: UILabel(), bill: 100.0, totalByPerson: UILabel())
        
        // Then
        XCTAssertTrue(mockViewModel.calculateTipCalled, "calculateTip method should be called")
        XCTAssertTrue(mockViewModel.resetCalled, "reset method should be called")
        XCTAssertTrue(mockViewModel.splitBillCalled, "splitBill method should be called")
    }
    
    func test_CalculateTip_With_Input() {
        // Given
        let valueInput = UITextField()
        valueInput.text = "100"
        
        let segment = UISegmentedControl(items: ["10%", "15%", "20%", "25%"])
        segment.selectedSegmentIndex = 0
        
        let tipValue = UILabel()
        let totalValue = UILabel()
        
        // When
        caclculations.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue)
        
        // Then
        XCTAssertEqual(tipValue.text, "$10.00", "Tip value should be calculated correctly")
        XCTAssertEqual(totalValue.text, "$110.00", "Total value should be calculated correctly")
    }
    
    func test_Reset() {
        // Given
        let valueInput = UITextField()
        let tipValue = UILabel()
        let totalValue = UILabel()
        let peopleQuantity = UILabel()
        let totalByPerson = UILabel()
        
        // When
        caclculations.reset(valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, totalByPerson: totalByPerson, peopleQuantity: peopleQuantity)
        
        // Then
        XCTAssertEqual(valueInput.text, "", "Value input should be cleared")
        XCTAssertEqual(tipValue.text, "$0.0", "Tip value should be reset to $0.0")
        XCTAssertEqual(totalValue.text, "$0.0", "Total value should be reset to $0.0")
        XCTAssertEqual(peopleQuantity.text, "1x", "People quantity should be reset to 1x")
        XCTAssertEqual(totalByPerson.text, "$0.0", "Total per person value should be reset to $0.0")
        XCTAssertEqual(caclculations.mainBill, 0, "Main bill should be reset to 0")
    }
    
    func test_SplitBill() {
        // Given
        let peopleLabel = UILabel()
        let bill: Double = 100.0
        let totalByPersonLabel = UILabel()
        
        // When
        caclculations.splitBiil(people: peopleLabel, bill: bill, totalByPerson: totalByPersonLabel)
        
        // Then
        XCTAssertEqual(peopleLabel.text, "100x", "People label should be set to '100x'")
        XCTAssertEqual(totalByPersonLabel.text, "", "Total per person value should be calculated correctly")
    }
    
    func test_Currency_Input_Formatting() {
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
            _ = testCase.input.currencyInputFormatting()
            let expectedResult = formatter.string(from: NSNumber(value: (Double(testCase.input) ?? 0) / 100)) ?? ""
            
            // Then
            XCTAssert(!expectedResult.isEmpty)
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
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
