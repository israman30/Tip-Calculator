//
//  Constants.swift
//  TipCalc
//
//  Created by Israel Manzo on 10/26/23.
//  Copyright © 2023 Israel Manzo. All rights reserved.
//

import Foundation

struct Constant {
    
    static let pin_circle = "pin.circle"
    static let pin_icon = "Pin Icon"
    static let xmark_circle = "xmark.circle"
    
    static let tip = "Tip"
    static let total = "Total"
    static let split_bill = "Split bill"
    static let zero = "$0.0"
    
    static let defaultDate = "00/00/2023"
    
    static let alert_ok = "Ok"
    static let alert_cancel = "Cancel"
    
    static let mic = "mic.fill"
    static let micStop = "stop.fill"
    
    static let savedCustomTipPercentKey = "savedCustomTipPercent"
    static let customCategoryTagsKey = "customCategoryTags"
    static let onboardingDismissedKey = "onboardingDismissed"
    
    static let savedBills = "Saved Bills"
    static let savedBillsTitle = "Saved bills title"
    
    struct Icon {
        static let arrow_counterclockwise = "arrow.counterclockwise"
        static let list_bullet_rectangle_fill = "list.bullet.rectangle.fill"
        static let chart_bar_doc_horizontal = "chart.bar.doc.horizontal"
        static let plus_circle = "plus.circle"
    }
}

/// Bill categories: Restaurant, Bar, Delivery, or custom user-defined tags
enum BillCategory: String, CaseIterable {
    case restaurant = "Restaurant"
    case bar = "Bar"
    case delivery = "Delivery"
    case custom = "Custom"

    var displayName: String {
        switch self {
        case .restaurant: return NSLocalizedString("Restaurant", comment: "Restaurant category")
        case .bar: return NSLocalizedString("Bar", comment: "Bar category")
        case .delivery: return NSLocalizedString("Delivery", comment: "Delivery category")
        case .custom: return NSLocalizedString("Custom", comment: "Custom category")
        }
    }

    static var predefinedCategories: [BillCategory] {
        [.restaurant, .bar, .delivery]
    }
}

/// Manages custom category tags stored in UserDefaults
struct CustomCategoryStorage {
    static var tags: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: Constant.customCategoryTagsKey) ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constant.customCategoryTagsKey)
        }
    }

    static func addTag(_ tag: String) {
        let trimmed = tag.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        var current = tags
        if let index = current.firstIndex(of: trimmed) {
            current.remove(at: index)
        }
        current.insert(trimmed, at: 0)
        tags = Array(current.prefix(20))
    }
}

struct LocalizedString {
    static let calculate_bill = NSLocalizedString("Tip Calculator", comment: "Tip Calculator")
    static let textField_placeholder = NSLocalizedString("Enter value", comment: "Enter value")
    static let textField_hint = NSLocalizedString("Input bill value", comment: "Input the bill value")
    static let tip_value_hint = NSLocalizedString("Tip value", comment: "Tip value")
    static let total_value_hint = NSLocalizedString("Total value tip", comment: "Total value, tip plus initial value")
    static let total_value_double_tap_hint = NSLocalizedString("Double tap for custom tip slider", comment: "Accessibility hint for custom tip")
    static let clear_value_button_title = NSLocalizedString("Clear values", comment: "CLEAR VALUES")
    
    static let no_value_to_be_saved = NSLocalizedString("No value to be saved", comment: "No value to be saved!")
    static let initial_bill = NSLocalizedString("initial bill", comment: "initial bill")
    static let seeAll = NSLocalizedString("Saved records..", comment: "")
    static let savedRecordsCount = NSLocalizedString("View saved bills (%d)", comment: "Button title with count of saved bills")
    
    static let emptyTableViewTitle = NSLocalizedString("There are currently no saved bills.", comment: "")
    static let emptyTableViewMessage = NSLocalizedString("To add a new bill, enter an amount and tap the pin button.", comment: "")
    static let swipeToDeleteHint = NSLocalizedString("Swipe left to delete", comment: "Swipe hint for saved bills")
    static let messageView = NSLocalizedString("Saving money is giving your future self a gift security, freedom, and peace of mind wrapped in every dollar set aside.", comment: "")
    
    static let insightsButtonTitle = NSLocalizedString("Insights", comment: "Spending insights button")
    static let spendingInsights = NSLocalizedString("Spending Insights", comment: "Insights dashboard title")
    static let yourTipAndSpendingOverview = NSLocalizedString("Your tip and spending overview", comment: "Insights subtitle")
    static let billSaved = NSLocalizedString("Bill saved!", comment: "VoiceOver announcement when bill is saved")
    static let customCategoryTitle = NSLocalizedString("Custom Category", comment: "Custom category alert title")
    static let messageCategory = NSLocalizedString("Enter a custom tag for this bill", comment: "Custom category alert message")
    static let placeholderCategory = NSLocalizedString("e.g. Coffee, Grocery", comment: "Custom tag placeholder")
    
    static let custom = NSLocalizedString("Custom", comment: "Add custom category")
}

struct AccessibilityLabels {
    static let pintButtonHint = NSLocalizedString("Tap for saving a bill.", comment: "")
    static let seeAllButtonHint = NSLocalizedString("Tap to display the list of bills.", comment: "")
    static let clearButtonHint = NSLocalizedString("Tap to reset bill amount and tip values.", comment: "")
    static let dictateBillValueLabel = NSLocalizedString("Dictate bill value", comment: "")
    static let dictateTipValueHint = NSLocalizedString("Tap to dictate bill value using your voice", comment: "")
    static let stopDictationLabel = NSLocalizedString("Stop dictation", comment: "")
    static let stopDictationHint = NSLocalizedString("Tap to stop voice input", comment: "")
    static let insightsButtonLabel = NSLocalizedString("Spending insights", comment: "")
    static let insightsButtonHint = NSLocalizedString("View spending insights dashboard", comment: "")
    static let dismissButtonLabel = NSLocalizedString("Close", comment: "Close button")
    static let dismissButtonHint = NSLocalizedString("Dismiss saved bills list", comment: "Dismiss hint")
    static let dismissInsights = NSLocalizedString("Dismiss insights", comment: "Dismiss hint")
}
