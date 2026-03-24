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

    var sut: SaveViewModel!
    var valueInput: UITextField!
    var tipValue: UILabel!
    var totalValue: UILabel!
    var splitTotal: UILabel!
    var splitPeopleQuantity: UILabel!
    var mockViewController: MockViewController!

    override func setUpWithError() throws {
        sut = SaveViewModel()
        valueInput = UITextField()
        tipValue = UILabel()
        totalValue = UILabel()
        splitTotal = UILabel()
        splitPeopleQuantity = UILabel()
        mockViewController = MockViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
        valueInput = nil
        tipValue = nil
        totalValue = nil
        splitTotal = nil
        splitPeopleQuantity = nil
        mockViewController = nil
    }

    private func configureValidSaveInputs() {
        valueInput.text = "50.00"
        tipValue.text = "$5.00"
        totalValue.text = "$55.00"
        splitTotal.text = "$27.50"
        splitPeopleQuantity.text = "2x"
    }

    // MARK: - Initial State

    func test_BillsArray_InitialState() {
        XCTAssertTrue(sut.bills.isEmpty, "The bills array should initially be empty")
    }

    func test_IsTotastVisible_InitialState() {
        XCTAssertFalse(sut.isTotastVisible, "Toast should not be visible initially")
    }

    func test_SortedBills_WhenEmpty_ReturnsEmptyArray() {
        XCTAssertTrue(sut.sortedBills.isEmpty)
    }

    // MARK: - Bills Array Operations

    func test_BillsArray_Add_Bill() {
        let bill = Bill(context: PersistanceServices.context)
        bill.input = String(100)

        sut.bills.append(bill)

        XCTAssertEqual(sut.bills.count, 1)
        XCTAssertEqual(sut.bills.first?.input, String(100))
    }

    func test_BillsArray_Clear() {
        let bill1 = Bill(context: PersistanceServices.context)
        bill1.input = String(100)
        let bill2 = Bill(context: PersistanceServices.context)
        bill2.input = String(200)
        sut.bills.append(bill1)
        sut.bills.append(bill2)

        sut.bills.removeAll()

        XCTAssertTrue(sut.bills.isEmpty)
    }

    // MARK: - Save - Empty / Invalid Input

    func test_Save_With_Empty_Input_ShowsAlert() {
        valueInput.text = ""
        tipValue.text = "$5.00"
        totalValue.text = "$55.00"
        splitTotal.text = "$27.50"
        splitPeopleQuantity.text = "2x"

        sut.save(mockViewController, valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, splitTotal: splitTotal, splitPeopleQuantity: splitPeopleQuantity, category: nil)

        XCTAssertNotNil(mockViewController.presentedAlert)
        XCTAssertEqual(mockViewController.presentedAlert?.title, "😵")
        XCTAssertEqual(mockViewController.presentedAlert?.message, LocalizedString.no_value_to_be_saved)
    }

    func test_Save_With_NilInput_ReturnsEarly_NoAlert() {
        valueInput.text = nil
        tipValue.text = "$5.00"
        totalValue.text = "$55.00"
        splitTotal.text = "$27.50"
        splitPeopleQuantity.text = "2x"

        sut.save(mockViewController, valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, splitTotal: splitTotal, splitPeopleQuantity: splitPeopleQuantity, category: nil)

        XCTAssertNotNil(mockViewController.presentedAlert)
        XCTAssertTrue(sut.bills.isEmpty)
    }

    func test_Save_With_NilTip_ReturnsEarly_NoAlert() {
        valueInput.text = "50"
        tipValue.text = nil
        totalValue.text = "$55"
        splitTotal.text = "$27.50"
        splitPeopleQuantity.text = "2x"

        sut.save(mockViewController, valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, splitTotal: splitTotal, splitPeopleQuantity: splitPeopleQuantity, category: nil)

        XCTAssertNil(mockViewController.presentedAlert)
        XCTAssertTrue(sut.bills.isEmpty)
    }

    func test_Save_With_NilTotal_ReturnsEarly_NoAlert() {
        valueInput.text = "50"
        tipValue.text = "$5"
        totalValue.text = nil
        splitTotal.text = "$27.50"
        splitPeopleQuantity.text = "2x"

        sut.save(mockViewController, valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, splitTotal: splitTotal, splitPeopleQuantity: splitPeopleQuantity, category: nil)

        XCTAssertNil(mockViewController.presentedAlert)
        XCTAssertTrue(sut.bills.isEmpty)
    }

    func test_Save_With_NilSplitTotal_ReturnsEarly_NoAlert() {
        configureValidSaveInputs()

        sut.save(mockViewController, valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, splitTotal: nil, splitPeopleQuantity: splitPeopleQuantity, category: nil)

        XCTAssertNil(mockViewController.presentedAlert)
        XCTAssertTrue(sut.bills.isEmpty)
    }

    func test_Save_With_NilSplitPeopleQuantity_ReturnsEarly_NoAlert() {
        configureValidSaveInputs()

        sut.save(mockViewController, valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, splitTotal: splitTotal, splitPeopleQuantity: nil, category: nil)

        XCTAssertNil(mockViewController.presentedAlert)
        XCTAssertTrue(sut.bills.isEmpty)
    }

    func test_Save_With_EmptySplitTotalText_ReturnsEarly_NoAlert() {
        valueInput.text = "50"
        tipValue.text = "$5"
        totalValue.text = "$55"
        splitTotal.text = nil
        splitPeopleQuantity.text = "2x"

        sut.save(mockViewController, valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, splitTotal: splitTotal, splitPeopleQuantity: splitPeopleQuantity, category: nil)

        XCTAssertNil(mockViewController.presentedAlert)
        XCTAssertTrue(sut.bills.isEmpty)
    }

    // MARK: - Save - Valid Input

    func test_Save_With_ValidInput_SavesBill_AndSetsToastVisible() {
        configureValidSaveInputs()

        sut.save(mockViewController, valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, splitTotal: splitTotal, splitPeopleQuantity: splitPeopleQuantity, category: nil)

        XCTAssertEqual(sut.bills.count, 1)
        XCTAssertTrue(sut.isTotastVisible)
        XCTAssertNil(mockViewController.presentedAlert)
    }

    func test_Save_With_ValidInput_ResignsFirstResponder() {
        configureValidSaveInputs()
        let window = UIWindow()
        window.addSubview(valueInput)
        valueInput.becomeFirstResponder()
        XCTAssertTrue(valueInput.isFirstResponder)

        sut.save(mockViewController, valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, splitTotal: splitTotal, splitPeopleQuantity: splitPeopleQuantity, category: nil)

        XCTAssertFalse(valueInput.isFirstResponder)
    }

    // MARK: - savingInLocalstorage

    func test_SavingInLocalstorage_CreatesBillWithCorrectFormat() {
        let input = "100.00"
        let tip = "$18.00"
        let total = "$118.00"
        let splitTotal = "$59.00"
        let splitPeopleQuantity = "2x"

        sut.savingInLocalstorage(with: input, tip: tip, total: total, splitTotal: splitTotal, splitPeopleQuantity: splitPeopleQuantity, category: nil)

        XCTAssertEqual(sut.bills.count, 1)
        let bill = sut.bills.first!
        XCTAssertEqual(bill.input, "$\(input) \(LocalizedString.initial_bill)")
        XCTAssertEqual(bill.tip, "\(tip) tip")
        XCTAssertEqual(bill.total, "\(total) total")
        XCTAssertEqual(bill.splitTotal, splitTotal)
        XCTAssertEqual(bill.splitPeopleQuantity, splitPeopleQuantity)
        XCTAssertNotNil(bill.date)
    }

    func test_SavingInLocalstorage_WithNilCategory_UsesDefaultRestaurant() {
        sut.savingInLocalstorage(with: "50", tip: "$5", total: "$55", splitTotal: nil, splitPeopleQuantity: nil, category: nil)

        XCTAssertEqual(sut.bills.count, 1)
        XCTAssertEqual(sut.bills.first?.category, BillCategory.restaurant.rawValue)
    }

    func test_SavingInLocalstorage_WithCustomCategory_UsesProvidedCategory() {
        let category = BillCategory.bar.rawValue
        sut.savingInLocalstorage(with: "50", tip: "$5", total: "$55", splitTotal: nil, splitPeopleQuantity: nil, category: category)

        XCTAssertEqual(sut.bills.count, 1)
        XCTAssertEqual(sut.bills.first?.category, category)
    }

    func test_SavingInLocalstorage_AppendsToBillsArray() {
        sut.savingInLocalstorage(with: "50", tip: "$5", total: "$55", splitTotal: nil, splitPeopleQuantity: nil, category: nil)
        sut.savingInLocalstorage(with: "100", tip: "$20", total: "$120", splitTotal: nil, splitPeopleQuantity: nil, category: nil)

        XCTAssertEqual(sut.bills.count, 2)
    }

    // MARK: - sortedBills

    func test_SortedBills_SortsByDate_Ascending() {
        let bill1 = Bill(context: PersistanceServices.context)
        bill1.date = "Mar 20, 2026"
        bill1.input = "50"
        let bill2 = Bill(context: PersistanceServices.context)
        bill2.date = "Mar 23, 2026"
        bill2.input = "100"
        let bill3 = Bill(context: PersistanceServices.context)
        bill3.date = "Mar 15, 2026"
        bill3.input = "25"
        sut.bills = [bill1, bill2, bill3]

        let sorted = sut.sortedBills

        XCTAssertEqual(sorted.map { $0.date ?? "" }, ["Mar 15, 2026", "Mar 20, 2026", "Mar 23, 2026"])
    }

    func test_SortedBills_HandlesNilDates() {
        let billWithDate = Bill(context: PersistanceServices.context)
        billWithDate.date = "Mar 23, 2026"
        billWithDate.input = "50"
        let billWithoutDate = Bill(context: PersistanceServices.context)
        billWithoutDate.date = nil
        billWithoutDate.input = "100"
        sut.bills = [billWithDate, billWithoutDate]

        let sorted = sut.sortedBills

        XCTAssertEqual(sorted.count, 2)
    }

    // MARK: - displayToast

    func test_DisplayToast_WhenToastVisible_SetsToFalse() {
        sut.isTotastVisible = true

        sut.displayToast(UIView())

        XCTAssertFalse(sut.isTotastVisible)
    }

    func test_DisplayToast_WhenToastNotVisible_SetsToFalse() {
        sut.isTotastVisible = false

        sut.displayToast(UIView())

        XCTAssertFalse(sut.isTotastVisible)
    }

    // MARK: - fetchItems

    func test_FetchItems_DoesNotCrash() {
        sut.fetchItems()
        XCTAssertNotNil(sut.bills)
    }

    func test_FetchItems_UpdatesBillsArray() {
        sut.savingInLocalstorage(with: "50", tip: "$5", total: "$55", splitTotal: nil, splitPeopleQuantity: nil, category: nil)
        PersistanceServices.saveContext()

        let freshViewModel = SaveViewModel()
        freshViewModel.fetchItems()

        XCTAssertGreaterThanOrEqual(freshViewModel.bills.count, 1)
    }
}
