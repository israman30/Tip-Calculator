//
//  SpendingInsightsViewModelTests.swift
//  TipCalcTests
//
//  Created by Israel Manzo on 3/23/26.
//  Copyright © 2026 Israel Manzo. All rights reserved.
//

import XCTest
import CoreData
@testable import TipCalc

final class SpendingInsightsViewModelTests: XCTestCase {

    var sut: SpendingInsightsViewModel!

    override func setUpWithError() throws {
        sut = SpendingInsightsViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    // MARK: - Helper Methods

    private func makeBill(
        input: String,
        tip: String,
        total: String,
        dateString: String
    ) -> Bill {
        let bill = Bill(context: PersistanceServices.context)
        bill.input = input
        bill.tip = tip
        bill.total = total
        bill.date = dateString
        return bill
    }

    private func dateString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }

    private var todayDateString: String {
        dateString(for: Date())
    }

    private var dateInCurrentWeekString: String {
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: .day, value: -2, to: Date()) else {
            return todayDateString
        }
        return dateString(for: date)
    }

    private var dateInCurrentMonthString: String {
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: .day, value: -10, to: Date()) else {
            return todayDateString
        }
        return dateString(for: date)
    }

    private var dateOutsideCurrentWeekString: String {
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: .day, value: -10, to: Date()) else {
            return dateString(for: Date.distantPast)
        }
        return dateString(for: date)
    }

    private var dateOutsideCurrentMonthString: String {
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: .month, value: -2, to: Date()) else {
            return dateString(for: Date.distantPast)
        }
        return dateString(for: date)
    }

    // MARK: - Empty Bills

    func testTotalSpentThisWeek_WithEmptyBills_ReturnsZero() {
        let bills: [Bill] = []
        XCTAssertEqual(sut.totalSpentThisWeek(from: bills), 0)
    }

    func testTotalSpentThisMonth_WithEmptyBills_ReturnsZero() {
        let bills: [Bill] = []
        XCTAssertEqual(sut.totalSpentThisMonth(from: bills), 0)
    }

    func testTotalTipsThisWeek_WithEmptyBills_ReturnsZero() {
        let bills: [Bill] = []
        XCTAssertEqual(sut.totalTipsThisWeek(from: bills), 0)
    }

    func testTotalTipsThisMonth_WithEmptyBills_ReturnsZero() {
        let bills: [Bill] = []
        XCTAssertEqual(sut.totalTipsThisMonth(from: bills), 0)
    }

    func testAverageTipPercent_WithEmptyBills_ReturnsZero() {
        let bills: [Bill] = []
        XCTAssertEqual(sut.averageTipPercent(from: bills), 0)
    }

    func testAverageTipPercent_WithEmptyBills_WithPeriod_ReturnsZero() {
        let bills: [Bill] = []
        XCTAssertEqual(sut.averageTipPercent(from: bills, inPeriod: .weekOfYear, value: 1), 0)
    }

    // MARK: - Currency Parsing (via totals and tips)

    func testTotalSpentThisWeek_ParsesDollarFormat() {
        let bill = makeBill(
            input: "50.00",
            tip: "$5.00",
            total: "$55.00",
            dateString: todayDateString
        )
        XCTAssertEqual(sut.totalSpentThisWeek(from: [bill]), 55)
    }

    func testTotalSpentThisWeek_ParsesPlainNumber() {
        let bill = makeBill(
            input: "100",
            tip: "15",
            total: "115",
            dateString: todayDateString
        )
        XCTAssertEqual(sut.totalSpentThisWeek(from: [bill]), 115)
    }

    func testTotalSpentThisWeek_ParsesDecimalString() {
        let bill = makeBill(
            input: "25.50",
            tip: "3.82",
            total: "29.32",
            dateString: todayDateString
        )
        XCTAssertEqual(sut.totalSpentThisWeek(from: [bill]), 29.32)
    }

    func testTotalSpentThisWeek_HandlesMalformedCurrency_ReturnsZeroForInvalid() {
        let bill = makeBill(
            input: "50",
            tip: "invalid",
            total: "no-number",
            dateString: todayDateString
        )
        XCTAssertEqual(sut.totalSpentThisWeek(from: [bill]), 0)
    }

    func testTotalTipsThisWeek_ParsesVariousFormats() {
        let bill = makeBill(
            input: "100",
            tip: "$20.00 tip",
            total: "$120.00",
            dateString: todayDateString
        )
        XCTAssertEqual(sut.totalTipsThisWeek(from: [bill]), 20)
    }

    func testTotalSpentThisWeek_HandlesNilOrEmptyStrings() {
        let bill = Bill(context: PersistanceServices.context)
        bill.input = nil
        bill.tip = nil
        bill.total = nil
        bill.date = todayDateString
        XCTAssertEqual(sut.totalSpentThisWeek(from: [bill]), 0)
    }

    // MARK: - Date Filtering - Week

    func testTotalSpentThisWeek_IncludesBillsFromCurrentWeek() {
        let bill1 = makeBill(input: "50", tip: "10", total: "60", dateString: todayDateString)
        let bill2 = makeBill(input: "30", tip: "6", total: "36", dateString: dateInCurrentWeekString)
        let bills = [bill1, bill2]
        XCTAssertEqual(sut.totalSpentThisWeek(from: bills), 96)
    }

    func testTotalSpentThisWeek_ExcludesBillsOutsideCurrentWeek() {
        let bill = makeBill(
            input: "100",
            tip: "20",
            total: "120",
            dateString: dateOutsideCurrentWeekString
        )
        XCTAssertEqual(sut.totalSpentThisWeek(from: [bill]), 0)
    }

    func testTotalTipsThisWeek_IncludesOnlyBillsInCurrentWeek() {
        let billInWeek = makeBill(input: "100", tip: "20", total: "120", dateString: todayDateString)
        let billOutOfWeek = makeBill(
            input: "50",
            tip: "10",
            total: "60",
            dateString: dateOutsideCurrentMonthString
        )
        let bills = [billInWeek, billOutOfWeek]
        XCTAssertEqual(sut.totalTipsThisWeek(from: bills), 20)
    }

    // MARK: - Date Filtering - Month

    func testTotalSpentThisMonth_IncludesBillsFromCurrentMonth() {
        let bill1 = makeBill(input: "50", tip: "10", total: "60", dateString: todayDateString)
        let bill2 = makeBill(input: "40", tip: "8", total: "48", dateString: dateInCurrentMonthString)
        let bills = [bill1, bill2]
        XCTAssertEqual(sut.totalSpentThisMonth(from: bills), 108)
    }

    func testTotalSpentThisMonth_ExcludesBillsOutsideCurrentMonth() {
        let bill = makeBill(
            input: "100",
            tip: "20",
            total: "120",
            dateString: dateOutsideCurrentMonthString
        )
        XCTAssertEqual(sut.totalSpentThisMonth(from: [bill]), 0)
    }

    func testTotalTipsThisMonth_IncludesOnlyBillsInCurrentMonth() {
        let billInMonth = makeBill(input: "100", tip: "18", total: "118", dateString: todayDateString)
        let billOutOfMonth = makeBill(
            input: "50",
            tip: "10",
            total: "60",
            dateString: dateOutsideCurrentMonthString
        )
        let bills = [billInMonth, billOutOfMonth]
        XCTAssertEqual(sut.totalTipsThisMonth(from: bills), 18)
    }

    // MARK: - Date Parsing - Unparseable dates excluded

    func testTotalSpentThisWeek_ExcludesBillsWithInvalidDate() {
        let bill = makeBill(input: "50", tip: "10", total: "60", dateString: "not-a-valid-date")
        XCTAssertEqual(sut.totalSpentThisWeek(from: [bill]), 0)
    }

    func testTotalSpentThisWeek_ExcludesBillsWithNilDate() {
        let bill = Bill(context: PersistanceServices.context)
        bill.input = "50"
        bill.tip = "10"
        bill.total = "60"
        bill.date = nil
        XCTAssertEqual(sut.totalSpentThisWeek(from: [bill]), 0)
    }

    func testTotalSpentThisWeek_ParsesAlternateDateFormat() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        formatter.locale = Locale(identifier: "en_US")
        let dateStr = formatter.string(from: Date())
        let bill = makeBill(input: "50", tip: "10", total: "60", dateString: dateStr)
        XCTAssertEqual(sut.totalSpentThisWeek(from: [bill]), 60)
    }

    // MARK: - Average Tip Percent - All Bills (no period)

    func testAverageTipPercent_WithValidBills_ReturnsCorrectPercentage() {
        let bill1 = makeBill(input: "100", tip: "15", total: "115", dateString: todayDateString)
        let bill2 = makeBill(input: "50", tip: "10", total: "60", dateString: todayDateString)
        let bills = [bill1, bill2]
        let totalTip: Double = 15 + 10
        let totalBill: Double = 100 + 50
        let expected = (totalTip / totalBill) * 100
        XCTAssertEqual(sut.averageTipPercent(from: bills), expected, accuracy: 0.01)
    }

    func testAverageTipPercent_With20PercentTip_Returns20() {
        let bill = makeBill(input: "100", tip: "20", total: "120", dateString: todayDateString)
        XCTAssertEqual(sut.averageTipPercent(from: [bill]), 20, accuracy: 0.01)
    }

    func testAverageTipPercent_SkipsBillsWithZeroInput() {
        let billWithInput = makeBill(input: "100", tip: "20", total: "120", dateString: todayDateString)
        let billZeroInput = makeBill(input: "0", tip: "5", total: "5", dateString: todayDateString)
        let bills = [billWithInput, billZeroInput]
        XCTAssertEqual(sut.averageTipPercent(from: bills), 20, accuracy: 0.01)
    }

    func testAverageTipPercent_WithAllZeroInputs_ReturnsZero() {
        let bill = makeBill(input: "0", tip: "5", total: "5", dateString: todayDateString)
        XCTAssertEqual(sut.averageTipPercent(from: [bill]), 0)
    }

    func testAverageTipPercent_WithPeriodFilter_FiltersBills() {
        let billInWeek = makeBill(input: "100", tip: "20", total: "120", dateString: todayDateString)
        let billOutOfWeek = makeBill(
            input: "50",
            tip: "10",
            total: "60",
            dateString: dateOutsideCurrentMonthString
        )
        let bills = [billInWeek, billOutOfWeek]
        let result = sut.averageTipPercent(from: bills, inPeriod: .weekOfYear, value: 1)
        XCTAssertEqual(result, 20, accuracy: 0.01)
    }

    func testAverageTipPercent_WithMonthPeriod_FiltersBills() {
        let billInMonth = makeBill(input: "80", tip: "16", total: "96", dateString: dateInCurrentMonthString)
        let bills = [billInMonth]
        let result = sut.averageTipPercent(from: bills, inPeriod: .month, value: 1)
        XCTAssertEqual(result, 20, accuracy: 0.01)
    }

    // MARK: - Multiple Bills Aggregation

    func testTotalSpentThisWeek_SumMultipleBills() {
        let bills = [
            makeBill(input: "25", tip: "5", total: "30", dateString: todayDateString),
            makeBill(input: "50", tip: "10", total: "60", dateString: todayDateString),
            makeBill(input: "75", tip: "15", total: "90", dateString: dateInCurrentWeekString)
        ]
        XCTAssertEqual(sut.totalSpentThisWeek(from: bills), 180)
    }

    func testTotalTipsThisMonth_SumMultipleBills() {
        let bills = [
            makeBill(input: "100", tip: "15", total: "115", dateString: todayDateString),
            makeBill(input: "200", tip: "40", total: "240", dateString: dateInCurrentMonthString)
        ]
        XCTAssertEqual(sut.totalTipsThisMonth(from: bills), 55)
    }

    // MARK: - Edge Cases

    func testAverageTipPercent_WithDecimalValues() {
        let bill = makeBill(input: "33.33", tip: "6.67", total: "40.00", dateString: todayDateString)
        let expected = (6.67 / 33.33) * 100
        XCTAssertEqual(sut.averageTipPercent(from: [bill]), expected, accuracy: 0.1)
    }

    func testTotalSpentThisMonth_HandlesMixedValidAndInvalidDates() {
        let validBill = makeBill(input: "50", tip: "10", total: "60", dateString: todayDateString)
        let invalidDateBill = makeBill(input: "30", tip: "6", total: "36", dateString: "invalid")
        let bills = [validBill, invalidDateBill]
        XCTAssertEqual(sut.totalSpentThisMonth(from: bills), 60)
    }
}
