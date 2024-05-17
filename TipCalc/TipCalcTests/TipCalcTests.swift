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

    override func setUpWithError() throws {
        caclculations = CalculationsViewModel()
        mockViewModel = MockViewModel()
    }

    override func tearDownWithError() throws {
        caclculations = nil
        mockViewModel = nil
    }
    
    func test_MainBill_Initialization() {
        XCTAssertEqual(caclculations.mainBill, 0.0, "Initial value of mainBill should be 0.0")
    }
    
    func testViewModelBillCalculations() {
        // When
        mockViewModel.calculateTip(with: UITextField(), segment: UISegmentedControl(), tipValue: UILabel(), totalValue: UILabel())
        mockViewModel.reset(valueInput: UITextField(), tipValue: UILabel(), totalValue: UILabel(), totalByPerson: UILabel(), peopleQuantity: UILabel())
        mockViewModel.splitBiil(people: UILabel(), bill: 100.0, totalByPerson: UILabel())
        
        // Then
        XCTAssertTrue(mockViewModel.calculateTipCalled, "calculateTip method should be called")
        XCTAssertTrue(mockViewModel.resetCalled, "reset method should be called")
        XCTAssertTrue(mockViewModel.splitBillCalled, "splitBill method should be called")
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
