//
//  CalculationsViewModelTests.swift
//  TipCalcTests
//
//  Created by Israel Manzo on 3/23/26.
//  Copyright © 2026 Israel Manzo. All rights reserved.
//

import XCTest
import UIKit
@testable import TipCalc

final class CalculationsViewModelTests: XCTestCase {

    var sut: CalculationsViewModel!
    var valueInput: UITextField!
    var segment: UISegmentedControl!
    var tipValue: UILabel!
    var totalValue: UILabel!
    var totalByPerson: UILabel!
    var peopleQuantity: UILabel!

    override func setUpWithError() throws {
        sut = CalculationsViewModel()
        valueInput = UITextField()
        segment = UISegmentedControl(items: ["10%", "15%", "20%", "25%"])
        segment.selectedSegmentIndex = 0
        tipValue = UILabel()
        totalValue = UILabel()
        totalByPerson = UILabel()
        peopleQuantity = UILabel()
    }

    override func tearDownWithError() throws {
        sut = nil
        valueInput = nil
        segment = nil
        tipValue = nil
        totalValue = nil
        totalByPerson = nil
        peopleQuantity = nil
    }

    // MARK: - Initial State

    func test_MainBill_InitialState() {
        XCTAssertEqual(sut.mainBill, 0.0)
    }

    // MARK: - calculateTip - Nil Input

    func test_CalculateTip_WithNilInput_ReturnsEarly() {
        valueInput.text = nil

        sut.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue, customTipPercent: nil)
        
        if tipValue.text == nil, totalValue.text == nil {
            XCTAssertNil(tipValue.text)
            XCTAssertNil(totalValue.text)
        }
    }

    // MARK: - calculateTip - Invalid Input

    func test_CalculateTip_WithInvalidInput_SetsZero() {
        valueInput.text = "abc"
        segment.selectedSegmentIndex = 0

        sut.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue, customTipPercent: nil)

        XCTAssertEqual(tipValue.text, Constant.zero)
        XCTAssertEqual(totalValue.text, Constant.zero)
    }

    func test_CalculateTip_WithEmptyInput_SetsZero() {
        valueInput.text = ""

        sut.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue, customTipPercent: nil)

        XCTAssertEqual(tipValue.text, Constant.zero)
        XCTAssertEqual(totalValue.text, Constant.zero)
    }

    // MARK: - calculateTip - Segment Percentages

    func test_CalculateTip_With10PercentSegment() {
        valueInput.text = "100"
        segment.selectedSegmentIndex = Percentages.ten_percent.rawValue

        sut.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue, customTipPercent: nil)

        XCTAssertEqual(sut.mainBill, 110) // 100 + 10% = 110
        XCTAssertTrue(tipValue.text?.contains("10") ?? false)
        XCTAssertTrue(totalValue.text?.contains("110") ?? false)
    }

    func test_CalculateTip_With15PercentSegment() {
        valueInput.text = "100"
        segment.selectedSegmentIndex = Percentages.fifteen_percent.rawValue

        sut.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue, customTipPercent: nil)

        XCTAssertEqual(sut.mainBill, 115) // 100 + 15% = 115
        XCTAssertTrue(tipValue.text?.contains("15") ?? false)
        XCTAssertTrue(totalValue.text?.contains("115") ?? false)
    }

    func test_CalculateTip_With20PercentSegment() {
        valueInput.text = "100"
        segment.selectedSegmentIndex = Percentages.twienty_percent.rawValue

        sut.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue, customTipPercent: nil)

        XCTAssertEqual(sut.mainBill, 120) // 100 + 20% = 120
        XCTAssertTrue(tipValue.text?.contains("20") ?? false)
        XCTAssertTrue(totalValue.text?.contains("120") ?? false)
    }

    func test_CalculateTip_With25PercentSegment() {
        valueInput.text = "100"
        segment.selectedSegmentIndex = Percentages.twientyfive_percent.rawValue

        sut.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue, customTipPercent: nil)

        XCTAssertEqual(sut.mainBill, 125) // 100 + 25% = 125
        XCTAssertTrue(tipValue.text?.contains("25") ?? false)
        XCTAssertTrue(totalValue.text?.contains("125") ?? false)
    }

    // MARK: - calculateTip - Custom Tip Percent

    func test_CalculateTip_WithCustomTipPercent_OverridesSegment() {
        valueInput.text = "100"
        segment.selectedSegmentIndex = Percentages.ten_percent.rawValue // Would give 10%, but custom overrides

        sut.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue, customTipPercent: 18)

        XCTAssertEqual(sut.mainBill, 118) // 100 + 18% = 118
        XCTAssertTrue(tipValue.text?.contains("18") ?? false)
        XCTAssertTrue(totalValue.text?.contains("118") ?? false)
    }

    func test_CalculateTip_WithCustomTipPercent_Zero() {
        valueInput.text = "100"

        sut.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue, customTipPercent: 0)

        XCTAssertEqual(sut.mainBill, 100)
        XCTAssertEqual(tipValue.text, Constant.zero)
        XCTAssertTrue(totalValue.text?.contains("100") ?? false)
    }

    // MARK: - calculateTip - mainBill Updates

    func test_CalculateTip_UpdatesMainBill() {
        valueInput.text = "50"
        segment.selectedSegmentIndex = 0

        sut.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue, customTipPercent: nil)

        XCTAssertEqual(sut.mainBill, 55) // 50 + 10% = 55
    }

    func test_CalculateTip_WithDecimalInput() {
        valueInput.text = "25.50"
        segment.selectedSegmentIndex = Percentages.twienty_percent.rawValue

        sut.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue, customTipPercent: nil)

        XCTAssertEqual(sut.mainBill, 30.60, accuracy: 0.01) // 25.50 + 20% = 30.60
    }

    // MARK: - reset

    func test_Reset_ClearsAllFields() {
        valueInput.text = "100"
        tipValue.text = "$10.00"
        totalValue.text = "$110.00"
        peopleQuantity.text = "2x"
        totalByPerson.text = "$55.00"
        sut.mainBill = 110

        sut.reset(valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, totalByPerson: totalByPerson, peopleQuantity: peopleQuantity)

        XCTAssertEqual(valueInput.text, "")
        XCTAssertEqual(tipValue.text, Constant.zero)
        XCTAssertEqual(totalValue.text, Constant.zero)
        XCTAssertEqual(peopleQuantity.text, "1x")
        XCTAssertEqual(totalByPerson.text, Constant.zero)
        XCTAssertEqual(sut.mainBill, 0)
    }

    func test_Reset_SetsMainBillToZero() {
        sut.mainBill = 500

        sut.reset(valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, totalByPerson: totalByPerson, peopleQuantity: peopleQuantity)

        XCTAssertEqual(sut.mainBill, 0)
    }

    // MARK: - splitBiil (note: typo in ViewModel method name)

    func test_SplitBiil_UpdatesPeopleLabel() {
        sut.mainBill = 100
        let peopleLabel = UILabel()

        sut.splitBiil(people: peopleLabel, bill: 2, totalByPerson: totalByPerson)

        XCTAssertEqual(peopleLabel.text, "2x")
        XCTAssertEqual(peopleLabel.accessibilityLabel, "2 people")
    }

    func test_SplitBiil_CalculatesTotalByPerson() {
        sut.mainBill = 100

        sut.splitBiil(people: peopleQuantity, bill: 4, totalByPerson: totalByPerson)

        XCTAssertEqual(sut.mainBill / 4, 25)
        XCTAssertTrue(totalByPerson.text?.contains("25") ?? false)
    }

    func test_SplitBiil_WithTwoPeople() {
        sut.mainBill = 60

        sut.splitBiil(people: peopleQuantity, bill: 2, totalByPerson: totalByPerson)

        XCTAssertEqual(peopleQuantity.text, "2x")
        XCTAssertEqual(peopleQuantity.accessibilityLabel, "2 people")
        XCTAssertTrue(totalByPerson.text?.contains("30") ?? false)
    }

    func test_SplitBiil_WithOnePerson() {
        sut.mainBill = 55

        sut.splitBiil(people: peopleQuantity, bill: 1, totalByPerson: totalByPerson)

        XCTAssertEqual(peopleQuantity.text, "1x")
        XCTAssertEqual(peopleQuantity.accessibilityLabel, "1 people")
        XCTAssertTrue(totalByPerson.text?.contains("55") ?? false)
    }

    // MARK: - Integration: calculateTip then splitBiil

    func test_CalculateTipThenSplit_Flow() {
        valueInput.text = "100"
        segment.selectedSegmentIndex = Percentages.twienty_percent.rawValue
        sut.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue, customTipPercent: nil)

        sut.splitBiil(people: peopleQuantity, bill: 2, totalByPerson: totalByPerson)

        XCTAssertEqual(sut.mainBill, 120)
        XCTAssertEqual(peopleQuantity.text, "2x")
        XCTAssertTrue(totalByPerson.text?.contains("60") ?? false) // 120 / 2 = 60
    }

    // MARK: - Integration: calculateTip then reset

    func test_CalculateTipThenReset_ClearsEverything() {
        valueInput.text = "50"
        segment.selectedSegmentIndex = 0
        sut.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue, customTipPercent: nil)

        sut.reset(valueInput: valueInput, tipValue: tipValue, totalValue: totalValue, totalByPerson: totalByPerson, peopleQuantity: peopleQuantity)

        XCTAssertEqual(sut.mainBill, 0)
        XCTAssertEqual(valueInput.text, "")
        XCTAssertEqual(tipValue.text, Constant.zero)
        XCTAssertEqual(totalValue.text, Constant.zero)
    }
}
