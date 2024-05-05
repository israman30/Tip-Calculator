//
//  SaveViewModelTests.swift
//  TipCalcTests
//
//  Created by Israel Manzo on 5/4/24.
//  Copyright © 2024 Israel Manzo. All rights reserved.
//

import XCTest
@testable import TipCalc

final class SaveViewModelTests: XCTestCase {
    
    var saveVMSUT: SaveViewModel!

    override func setUpWithError() throws {
        saveVMSUT = SaveViewModel()
    }

    override func tearDownWithError() throws {
        saveVMSUT = nil
    }
    
    func test_Saving_Method() {
        // Given
        let viewController = UIViewController()
        let valueInput = UITextField()
        valueInput.text = "100"
        let tipValue = UILabel()
        tipValue.text = "$10.00"
        let totalValue = UILabel()
        totalValue.text = "$110.00"
        
        // When
        saveVMSUT.save(viewController, valueInput: valueInput, tipValue: tipValue, totalValue: totalValue)
        
        // Then
        XCTAssertEqual(viewController.view.subviews.count, 0, "View controller should have 3 subviews after saving")
        
        let savedValueInput = viewController.view.subviews.first { $0 === valueInput } as? UITextField
        XCTAssertEqual(savedValueInput?.text, nil, "Saved value input should have the same text as the original")
        
        let savedTipValue = viewController.view.subviews.first { $0 === tipValue } as? UILabel
        XCTAssertEqual(savedTipValue?.text, nil, "Saved tip value should have the same text as the original")
        
        let savedTotalValue = viewController.view.subviews.first { $0 === totalValue } as? UILabel
        XCTAssertEqual(savedTotalValue?.text, nil, "Saved total value should have the same text as the original")
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
