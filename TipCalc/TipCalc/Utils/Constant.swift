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
    
    static let mic = "mic"
}

struct LocalizedString {
    static let calculate_bill = NSLocalizedString("Tip Calculator", comment: "Calculate tip")
    static let textField_placeholder = NSLocalizedString("Enter value", comment: "Enter value")
    static let textField_hint = NSLocalizedString("Input bill value", comment: "Input the bill value")
    static let tip_value_hint = NSLocalizedString("Tip value", comment: "Tip value")
    static let total_value_hint = NSLocalizedString("Total value tip", comment: "Total value, tip plus initial value")
    static let clear_value_button_title = NSLocalizedString("Clear values", comment: "CLEAR VALUES")
    
    static let no_value_to_be_saved = NSLocalizedString("No value to be saved", comment: "No value to be saved!")
    static let initial_bill = NSLocalizedString("initial bill", comment: "initial bill")
    static let seeAll = NSLocalizedString("See all saved records..", comment: "")
    
    static let emptyTableViewTitle = NSLocalizedString("There are currently no saved bills.", comment: "")
    static let emptyTableViewMessage = NSLocalizedString("To add a new bill, enter an amount and tap the pin button.", comment: "")
    static let messageView = NSLocalizedString("Saving money is giving your future self a gift security, freedom, and peace of mind wrapped in every dollar set aside.", comment: "")
}

struct AccessibilityLabels {
    static let pintButtonHint = NSLocalizedString("Tap for saving a bill.", comment: "")
    static let seeAllButtonHint = NSLocalizedString("Tap to display the list of bills.", comment: "")
    static let clearButtonHint = NSLocalizedString("Tap to clear all saved bills.", comment: "")
    static let dictateBillValueLabel = NSLocalizedString("Dictate bill value", comment: "")
    static let dictateTipValueHint = NSLocalizedString("Tap to dictate bill value using your voice", comment: "")
}
