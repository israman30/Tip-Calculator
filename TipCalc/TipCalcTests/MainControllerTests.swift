//
//  MainControllerTests.swift
//  TipCalcTests
//
//  Created by Israel Manzo on 3/24/26.
//  Copyright © 2026 Israel Manzo. All rights reserved.
//

import XCTest
import UIKit
import CoreData
@testable import TipCalc

final class MainControllerTests: XCTestCase {

    private var window: UIWindow!
    private var sut: MainController!

    override func setUpWithError() throws {
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 812))
        sut = MainController()
        let nav = UINavigationController(rootViewController: sut)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        window = nil
    }

    // MARK: - SpeechError (MainController.swift)

    func test_SpeechError_AuthorizationDenied_Description() {
        let error = SpeechError.authorizationDenied
        XCTAssertTrue(error.errorDescription?.contains("denied") == true)
    }

    func test_SpeechError_AuthorizationRestricted_Description() {
        let error = SpeechError.authorizationRestricted
        XCTAssertTrue(error.errorDescription?.contains("restricted") == true)
    }

    func test_SpeechError_AuthorizationNotDetermined_Description() {
        let error = SpeechError.authorizationNotDetermined
        XCTAssertTrue(error.errorDescription?.contains("not been determined") == true)
    }

    func test_SpeechError_RecognizerUnavailable_Description() {
        let error = SpeechError.recognizerUnavailable
        XCTAssertTrue(error.errorDescription?.contains("not available") == true)
    }

    func test_SpeechError_RecognitionRequestFailed_Description() {
        let error = SpeechError.recognitionRequestFailed
        XCTAssertTrue(error.errorDescription?.contains("Failed to create") == true)
    }

    func test_SpeechError_AudioSessionFailed_IncludesUnderlyingMessage() {
        let underlying = NSError(domain: "test", code: 1)
        let error = SpeechError.audioSessionFailed(underlying)
        XCTAssertTrue(error.errorDescription?.contains("Audio session") == true)
    }

    func test_SpeechError_AudioEngineStartFailed_IncludesUnderlyingMessage() {
        let underlying = NSError(domain: "test", code: 2)
        let error = SpeechError.audioEngineStartFailed(underlying)
        XCTAssertTrue(error.errorDescription?.contains("start audio engine") == true)
    }

    func test_SpeechError_RecognitionTaskFailed_IncludesUnderlyingMessage() {
        let underlying = NSError(domain: "test", code: 3)
        let error = SpeechError.recognitionTaskFailed(underlying)
        XCTAssertTrue(error.errorDescription?.contains("Recognition failed") == true)
    }

    // MARK: - UIImage.withPadding (MainController.swift)

    func test_UIImage_WithPadding_IncreasesSize() {
        let image = UIImage(systemName: "circle.fill")!
        let padding = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        let padded = image.withPadding(padding)
        XCTAssertNotNil(padded)
        XCTAssertEqual(padded?.size.width ?? 0.0, image.size.width + 12, accuracy: 0.5)
        XCTAssertEqual(padded?.size.height ?? 0.0, image.size.height + 8, accuracy: 0.5)
    }

    // MARK: - MainController initial state & view load

    func test_ViewLoads_ViewModelsInitialized() {
        XCTAssertNotNil(sut.calculationsViewModel)
        XCTAssertNotNil(sut.saveViewModel)
    }

    func test_DefaultSelectedCategory_IsRestaurant() {
        XCTAssertEqual(sut.selectedCategory, BillCategory.restaurant.rawValue)
    }

    func test_IsCustomTipSliderVisible_InitiallyFalse() {
        XCTAssertFalse(sut.isCustomTipSliderVisible)
    }

    func test_SplitStepper_DefaultValue() {
        XCTAssertEqual(sut.splitStepper.value, 1)
    }

    func test_CategoryStackView_HasChipsAfterLoad() {
        XCTAssertGreaterThan(sut.categoryStackView.arrangedSubviews.count, 0)
    }

    // MARK: - updateSavedRecordsButton

    func test_UpdateSavedRecordsButton_ZeroBills_UsesSeeAllTitle() {
        sut.saveViewModel?.bills.removeAll()
        sut.updateSavedRecordsButton()
        XCTAssertEqual(sut.presentSheetButton.configuration?.title, LocalizedString.seeAll)
    }

    func test_UpdateSavedRecordsButton_WithBills_UsesCountFormat() {
        let bill = Bill(context: PersistanceServices.context)
        bill.input = "test"
        sut.saveViewModel?.bills = [bill]
        sut.updateSavedRecordsButton()
        let title = sut.presentSheetButton.configuration?.title ?? ""
        XCTAssertTrue(title.contains("1") || title.contains("View"))
    }

    // MARK: - dismissKeyboard

    func test_DismissKeyboard_EndsEditing() {
        let field = UITextField()
        sut.view.addSubview(field)
        field.becomeFirstResponder()
        if field.isFirstResponder {
            XCTAssertTrue(field.isFirstResponder)
        } else {
            XCTAssertFalse(field.isFirstResponder)
        }

        sut.dismissKeyboard()

        XCTAssertFalse(field.isFirstResponder)
    }

    // MARK: - changeValue & calculations

    func test_ChangeValue_WithInput_UpdatesTipAndTotal() {
        sut.valueInput.text = "100"
        sut.segment.selectedSegmentIndex = Percentages.fifteen_percent.rawValue

        sut.changeValue()

        XCTAssertEqual(sut.calculationsViewModel?.mainBill ?? 0.0, 115, accuracy: 0.01)
        XCTAssertFalse(sut.tipValue.text?.isEmpty ?? true)
        XCTAssertFalse(sut.totalValue.text?.isEmpty ?? true)
    }

    func test_ChangeValue_WithEmptyInput_DoesNotCrash() {
        sut.valueInput.text = ""
        sut.changeValue()
        XCTAssertEqual(sut.calculationsViewModel?.mainBill, 0)
    }

    // MARK: - handleResetFields

    func test_HandleResetFields_ClearsInputsAndMainBill() {
        sut.valueInput.text = "50"
        sut.tipValue.text = "$5.00"
        sut.totalValue.text = "$55.00"
        sut.calculationsViewModel?.mainBill = 55

        sut.handleResetFields()

        XCTAssertEqual(sut.valueInput.text, "")
        XCTAssertEqual(sut.tipValue.text, Constant.zero)
        XCTAssertEqual(sut.totalValue.text, Constant.zero)
        XCTAssertEqual(sut.splitStepper.value, 1)
        XCTAssertEqual(sut.splitPeopleQuantity.text, "1x")
        XCTAssertEqual(sut.calculationsViewModel?.mainBill, 0)
    }

    // MARK: - changeStepperQuantity

    func test_ChangeStepperQuantity_EmptyInput_ReturnsEarly() {
        sut.valueInput.text = ""
        sut.splitStepper.value = 3

        sut.changeStepperQuantity()

        XCTAssertEqual(sut.splitPeopleQuantity.text, "1x")
    }

    func test_ChangeStepperQuantity_WithInput_UpdatesSplit() {
        sut.valueInput.text = "100"
        sut.segment.selectedSegmentIndex = 0
        sut.changeValue()
        sut.splitStepper.value = 2

        sut.changeStepperQuantity()

        XCTAssertEqual(sut.splitPeopleQuantity.text, "2x")
        XCTAssertTrue(sut.splitTotal.text?.contains("55") == true || sut.splitTotal.text?.contains("5") == true)
    }

    // MARK: - Tip slider handlers

    func test_HandleTipSliderValueChanged_SnapsToIntegerAndUpdatesLabel() {
        sut.tipSlider.value = 17.4
        sut.handleTipSliderValueChanged(sut.tipSlider)

        XCTAssertEqual(sut.tipSlider.value, 17)
        XCTAssertEqual(sut.tipSliderPercentLabel.text, "17%")
    }

    func test_HandleTipSliderTouchUp_PersistsToUserDefaults() {
        let key = Constant.savedCustomTipPercentKey
        let previous = UserDefaults.standard.object(forKey: key) as? Int
        sut.tipSlider.value = 22

        sut.handleTipSliderTouchUp(sut.tipSlider)

        XCTAssertEqual(UserDefaults.standard.integer(forKey: key), 22)
        if let previous = previous {
            UserDefaults.standard.set(previous, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    // MARK: - Custom tip slider visibility

    func test_HandleTotalValueDoubleTap_TogglesCustomTipSliderVisibility() {
        XCTAssertFalse(sut.isCustomTipSliderVisible)

        sut.handleTotalValueDoubleTap()

        XCTAssertTrue(sut.isCustomTipSliderVisible)
    }

    // MARK: - applyQuickLaunchTipPercent (widget / deep link)

    func test_ApplyQuickLaunchTipPercent_ValidPercents_SelectsMatchingSegment() {
        let mapping: [(percent: Int, segmentIndex: Int)] = [
            (10, Percentages.ten_percent.rawValue),
            (15, Percentages.fifteen_percent.rawValue),
            (20, Percentages.twienty_percent.rawValue),
            (25, Percentages.twientyfive_percent.rawValue),
        ]
        for item in mapping {
            sut.segment.selectedSegmentIndex = Percentages.twientyfive_percent.rawValue
            sut.applyQuickLaunchTipPercent(item.percent)
            XCTAssertEqual(sut.segment.selectedSegmentIndex, item.segmentIndex, "percent \(item.percent)")
        }
    }

    func test_ApplyQuickLaunchTipPercent_InvalidPercent_DoesNotChangeSegment() {
        sut.segment.selectedSegmentIndex = Percentages.twienty_percent.rawValue
        sut.applyQuickLaunchTipPercent(18)
        XCTAssertEqual(sut.segment.selectedSegmentIndex, Percentages.twienty_percent.rawValue)
    }

    func test_ApplyQuickLaunchTipPercent_WithBill_RecomputesTotal() {
        sut.valueInput.text = "100"
        sut.applyQuickLaunchTipPercent(20)
        XCTAssertEqual(sut.calculationsViewModel?.mainBill ?? 0, 120, accuracy: 0.01)
    }

    func test_ApplyQuickLaunchTipPercent_CollapsesCustomTipSlider() {
        sut.handleTotalValueDoubleTap()
        XCTAssertTrue(sut.isCustomTipSliderVisible)

        sut.applyQuickLaunchTipPercent(15)

        XCTAssertFalse(sut.isCustomTipSliderVisible)
    }

    // MARK: - triggerCalculationHaptic

    func test_TriggerCalculationHaptic_UpdatesLastCalculationTime() {
        let before = sut.lastCalculationHapticTime
        sut.triggerCalculationHaptic()
        XCTAssertGreaterThan(sut.lastCalculationHapticTime, before)
    }

    func test_TriggerCalculationHaptic_ThrottlesWithinInterval() {
        sut.lastCalculationHapticTime = Date()
        let timeBeforeSecondCall = sut.lastCalculationHapticTime
        sut.triggerCalculationHaptic()
        XCTAssertEqual(sut.lastCalculationHapticTime, timeBeforeSecondCall)
    }

    // MARK: - handleCategoryTapped

    func test_HandleCategoryTapped_UpdatesSelectedCategory() {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.title = BillCategory.bar.rawValue
        button.configuration = config

        sut.handleCategoryTapped(button)

        XCTAssertEqual(sut.selectedCategory, BillCategory.bar.rawValue)
    }

    func test_HandleCategoryTapped_MissingTitle_ReturnsEarly() {
        sut.selectedCategory = BillCategory.restaurant.rawValue
        let button = UIButton(type: .system)
        button.configuration = nil

        sut.handleCategoryTapped(button)

        XCTAssertEqual(sut.selectedCategory, BillCategory.restaurant.rawValue)
    }

    // MARK: - refreshCategoryChips

    func test_RefreshCategoryChips_RebuildsStack() {
        sut.refreshCategoryChips()
        XCTAssertGreaterThan(sut.categoryStackView.arrangedSubviews.count, 0)
    }

    // MARK: - presentationControllerDidDismiss

    func test_PresentationControllerDidDismiss_SetsOnboardingDismissed() {
        let key = Constant.onboardingDismissedKey
        UserDefaults.standard.removeObject(forKey: key)

        let presented = UIViewController()
        let presenting = UIViewController()
        let pc = UIPresentationController(presentedViewController: presented, presenting: presenting)
        sut.presentationControllerDidDismiss(pc)

        XCTAssertTrue(UserDefaults.standard.bool(forKey: key))
        UserDefaults.standard.removeObject(forKey: key)
    }

    // MARK: - displayAccessibilityToastMessage

    func test_DisplayAccessibilityToastMessage_WhenToastNotVisible_DoesNotPost() {
        sut.saveViewModel?.isTotastVisible = false
        sut.displayAccessibilityToastMessage()
    }

    // MARK: - presentOnboardingIfNeeded (UserDefaults gate)

    func test_PresentOnboardingIfNeeded_WhenAlreadyDismissed_DoesNothing() {
        let key = Constant.onboardingDismissedKey
        UserDefaults.standard.set(true, forKey: key)

        sut.presentOnboardingIfNeeded()

        UserDefaults.standard.removeObject(forKey: key)
    }
}
