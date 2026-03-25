//
//  MainHandlersExtTests.swift
//  TipCalcTests
//
//  Unit tests for MainController behavior implemented in MainHandlers+Ext.swift
//

import XCTest
import UIKit
@testable import TipCalc

final class MainHandlersExtTests: XCTestCase {

    private var window: UIWindow!
    private var sut: MainController!

    override func setUpWithError() throws {
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 812))
        sut = MainController()
        window.rootViewController = UINavigationController(rootViewController: sut)
        window.makeKeyAndVisible()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        window = nil
    }

    // MARK: - changeValue (custom tip path)

    func test_ChangeValue_WithCustomSliderVisible_UsesSliderPercentNotSegment() {
        sut.valueInput.text = "100"
        sut.segment.selectedSegmentIndex = Percentages.ten_percent.rawValue
        sut.handleTotalValueDoubleTap()
        XCTAssertTrue(sut.isCustomTipSliderVisible)

        sut.tipSlider.value = 18
        sut.changeValue()

        XCTAssertEqual(sut.calculationsViewModel?.mainBill ?? 0, 118, accuracy: 0.01)
    }

    func test_ChangeValue_WithInput_TriggersCalculationHapticWhenNotThrottled() {
        sut.lastCalculationHapticTime = .distantPast
        sut.valueInput.text = "40"
        sut.segment.selectedSegmentIndex = Percentages.fifteen_percent.rawValue

        let before = sut.lastCalculationHapticTime
        sut.changeValue()

        XCTAssertGreaterThan(sut.lastCalculationHapticTime, before)
    }

    func test_ChangeValue_WithEmptyInput_DoesNotAdvanceHapticTime() {
        sut.lastCalculationHapticTime = .distantPast
        sut.valueInput.text = ""

        let before = sut.lastCalculationHapticTime
        sut.changeValue()

        XCTAssertEqual(sut.lastCalculationHapticTime, before)
    }

    // MARK: - toggleCustomTipSlider (via handleTotalValueDoubleTap)

    func test_HandleTotalValueDoubleTap_SecondTap_HidesCustomSlider() {
        sut.handleTotalValueDoubleTap()
        XCTAssertTrue(sut.isCustomTipSliderVisible)

        sut.handleTotalValueDoubleTap()
        XCTAssertFalse(sut.isCustomTipSliderVisible)
    }

    func test_HandleTotalValueDoubleTap_WhenShowing_SetsPercentLabelAndRecalculates() {
        sut.valueInput.text = "200"
        sut.segment.selectedSegmentIndex = 0
        sut.tipSlider.value = 12
        sut.handleTotalValueDoubleTap()

        XCTAssertEqual(sut.tipSliderPercentLabel.text, "12%")
        XCTAssertEqual(sut.calculationsViewModel?.mainBill ?? 0, 224, accuracy: 0.01)
    }

    // MARK: - handleTipSliderValueChanged

    func test_HandleTipSliderValueChanged_WithBillAndSliderVisible_UpdatesFromCustomPercent() {
        sut.valueInput.text = "100"
        sut.handleTotalValueDoubleTap()
        sut.tipSlider.value = 22

        sut.handleTipSliderValueChanged(sut.tipSlider)

        XCTAssertEqual(sut.tipSlider.value, 22)
        XCTAssertEqual(sut.calculationsViewModel?.mainBill ?? 0, 122, accuracy: 0.01)
    }

    // MARK: - refreshCategoryChips & CustomCategoryStorage

    func test_RefreshCategoryChips_IncludesTagsFromCustomCategoryStorage() {
        let key = Constant.customCategoryTagsKey
        let previous = UserDefaults.standard.stringArray(forKey: key)
        CustomCategoryStorage.tags = ["WidgetTestTag"]

        sut.refreshCategoryChips()

        let titles = sut.categoryStackView.arrangedSubviews.compactMap { view -> String? in
            guard let button = view as? UIButton else { return nil }
            return button.configuration?.title
        }
        XCTAssertTrue(titles.contains("WidgetTestTag"))

        if let previous {
            UserDefaults.standard.set(previous, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    // MARK: - setupTotalValueDoubleTap

    func test_SetupTotalValueDoubleTap_AttachesDoubleTapRecognizer() {
        let hasDoubleTap = sut.totalValue.gestureRecognizers?.contains { recognizer in
            guard let tap = recognizer as? UITapGestureRecognizer else { return false }
            return tap.numberOfTapsRequired == 2
        } ?? false
        XCTAssertTrue(hasDoubleTap)
    }
}
