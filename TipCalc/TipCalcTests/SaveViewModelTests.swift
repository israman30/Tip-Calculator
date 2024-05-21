//
//  SaveViewModelTests.swift
//  TipCalcTests
//
//  Created by Israel Manzo on 5/18/24.
//  Copyright © 2024 Israel Manzo. All rights reserved.
//

import XCTest
import CoreData
@testable import TipCalc

class MockViewController: UIViewController {
    var presentedAlert: UIAlertController?

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let alert = viewControllerToPresent as? UIAlertController {
            presentedAlert = alert
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

final class SaveViewModelTests: XCTestCase {
    
    var savingViewModel: SaveViewModel!
    var valueInput: UITextField!
    var tipValue: UILabel!
    var totalValue: UILabel!
    var splitTotal: UILabel!
    var splitPeopleQuantity: UILabel!
    var mockViewController: MockViewController!

    override func setUpWithError() throws {
        savingViewModel = SaveViewModel()
        valueInput = UITextField()
        tipValue = UILabel()
        totalValue = UILabel()
        splitTotal = UILabel()
        splitPeopleQuantity = UILabel()
        mockViewController = MockViewController()
    }

    override func tearDownWithError() throws {
        savingViewModel = nil
        valueInput = nil
        tipValue = nil
        totalValue = nil
        splitTotal = nil
        splitPeopleQuantity = nil
        mockViewController = nil
    }
    
    func test_BillsArray_InitialState() {
        // Then
        XCTAssertTrue(savingViewModel.bills.isEmpty, "The bills array should initially be empty")
    }
    
    func test_BillsArray_Add_Bill() {
        // Given
        let bill = Bill(context: PersistanceServices.context)
        bill.input = String(100)
        
        // When
        savingViewModel.bills.append(bill) // Simulate adding a bill to the array
        
        // Then
        XCTAssertEqual(savingViewModel.bills.count, 1, "The bills array should contain one bill")
        XCTAssertEqual(savingViewModel.bills.first?.input, String(100), "The bill in the array should have the correct amount")
    }
    
    func test_BillsArray_Clear() {
        // Given
        let bill1 = Bill(context: PersistanceServices.context)
        bill1.input = String(100)
        let bill2 = Bill(context: PersistanceServices.context)
        bill2.input = String(200)
        
        savingViewModel.bills.append(bill1)
        savingViewModel.bills.append(bill2)
        
        // When
        savingViewModel.bills.removeAll() // Simulate clearing the array
        
        // Then
        XCTAssertTrue(savingViewModel.bills.isEmpty, "The bills array should be empty after clearing")
    }
    
    func test_Save_With_Empty_Input_ShowsAlert() {
        // Given
        valueInput.text = ""
        tipValue.text = "$5.00"
        totalValue.text = "$55.00"
        splitTotal.text = "$27.50"
        splitPeopleQuantity.text = "2x"
        
        // When
        savingViewModel.save(mockViewController, valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, splitTotal: splitTotal, splitPeopleQuantity: splitPeopleQuantity)
        
        // Then
        XCTAssertNotNil(mockViewController.presentedAlert, "An alert should be presented when the input is empty")
        XCTAssertEqual(mockViewController.presentedAlert?.title, "😵", "The alert title should be correct")
        XCTAssertEqual(mockViewController.presentedAlert?.message, LocalizedString.no_value_to_be_saved, "The alert message should be correct")
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
