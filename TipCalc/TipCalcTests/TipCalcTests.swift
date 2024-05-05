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
    
    var calculationsProtocolSUT: CalculationsViewModel!
    var calculationVMSUT: CalculationsViewModel!

    override func setUpWithError() throws {
        calculationsProtocolSUT = CalculationsViewModel()
        calculationVMSUT = CalculationsViewModel()
    }

    override func tearDownWithError() throws {
        calculationsProtocolSUT = nil
        calculationVMSUT = nil
    }
    
    func test_CalculateTip_Method() {
        // Given
        let valueInput = UITextField()
        valueInput.text = "100"
        
        let segment = UISegmentedControl(items: ["10%", "15%", "20%"])
        segment.selectedSegmentIndex = 0
        
        let tipValue = UILabel()
        let totalValue = UILabel()
        
        // When
        calculationsProtocolSUT.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue)
        
        // Then
        XCTAssertEqual(tipValue.text, "$10.00", "Tip value should be calculated correctly")
        XCTAssertEqual(totalValue.text, "$110.00", "Total value should be calculated correctly")
    }
    
    func test_Reset_Values_WithNoError() {
        // Given
        let valueInput = UITextField()
        valueInput.text = "100"
        
        let tipValue = UILabel()
        tipValue.text = "10.0"
        
        let totalValue = UILabel()
        totalValue.text = "110.0"
        
        let totalByPerson = UILabel()
        totalByPerson.text = "27.5"
        
        let peopleQuantity = UILabel()
        peopleQuantity.text = "4"
        
        // When
        calculationsProtocolSUT.reset(valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, totalByPerson: totalByPerson, peopleQuantity: peopleQuantity)
        
        // Then
        XCTAssertEqual(valueInput.text, "", "Value input should be cleared")
        XCTAssertEqual(tipValue.text, "$0.0", "Tip value should be reset to 0.0")
        XCTAssertEqual(totalValue.text, "$0.0", "Total value should be reset to 0.0")
        XCTAssertEqual(totalByPerson.text, "$0.0", "Total per person value should be reset to 0.0")
        XCTAssertEqual(peopleQuantity.text, "1x", "People quantity should be reset to 1")
    }
    
    func test_SplitBill() {
        // Given
        let peopleLabel = UILabel()
        peopleLabel.text = "4"
        
        let billAmount: Double = 100.0
        
        let totalByPersonLabel = UILabel()
        totalByPersonLabel.text = "25.0"
        
        // When
        calculationsProtocolSUT.splitBiil(people: peopleLabel, bill: billAmount, totalByPerson: totalByPersonLabel)
        
        // Then
        XCTAssertEqual(totalByPersonLabel.text, "", "Total per person should remain the same if the number of people is unchanged")
    }
    
    func test_MainBill_Initialization() {
        // Given
        let mainBill = calculationVMSUT.mainBill
        
        // Then
        XCTAssertEqual(mainBill, 0.0, "Initial value of mainBill should be 0.0")
        XCTAssertTrue(!mainBill.isNaN)
        XCTAssertTrue(mainBill.isZero)
    }
    
    func test_Calculate_Tip() {
        // Given
        let valueInput = UITextField()
        valueInput.text = "100"
        
        let segment = UISegmentedControl(items: ["10%", "15%", "20%", "25%"])
        segment.selectedSegmentIndex = 0
        
        let tipValue = UILabel()
        let totalValue = UILabel()
        
        // When
        calculationVMSUT.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue)
        
        // Then
        XCTAssertEqual(tipValue.text, "$10.00", "Tip value should be calculated correctly")
        XCTAssertEqual(totalValue.text, "$110.00", "Total value should be calculated correctly")
    }
    
    func test_Reset_Values_Method() {
        // Given
        let valueInput = UITextField()
        let tipValue = UILabel()
        let totalValue = UILabel()
        let peopleQuantity = UILabel()
        let totalByPerson = UILabel()
        
        // When
        calculationVMSUT.reset(valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, totalByPerson: totalByPerson, peopleQuantity: peopleQuantity)
        
        // Then
        XCTAssertEqual(valueInput.text, "", "Value input should be cleared")
        XCTAssertEqual(tipValue.text, "$0.0", "Tip value should be reset to $0.0")
        XCTAssertEqual(totalValue.text, "$0.0", "Total value should be reset to $0.0")
        XCTAssertEqual(peopleQuantity.text, "1x", "People quantity should be reset to 1x")
        XCTAssertEqual(totalByPerson.text, "$0.0", "Total per person value should be reset to $0.0")
        XCTAssertEqual(calculationVMSUT.mainBill, 0, "Main bill should be reset to 0")
    }
    
    func test_SplitBill_VMMethod() {
        // Given
        let peopleLabel = UILabel()
        let bill: Double = 100.0
        let totalByPersonLabel = UILabel()
        
        // When
        calculationVMSUT.splitBiil(people: peopleLabel, bill: bill, totalByPerson: totalByPersonLabel)
        
        // Then
        XCTAssertEqual(peopleLabel.text, "100x", "People label should be set to '100x'")
        XCTAssertEqual(totalByPersonLabel.text, "$1.00", "Total per person value should be calculated correctly")
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
