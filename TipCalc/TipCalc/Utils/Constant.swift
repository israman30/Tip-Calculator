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
    
    static let tip = "Tip"
    static let total = "Total"
    static let split_bill = "Split bill"
    static let zero = "$0.0"
    
    static let defaultDate = "00/00/2023"
    
    static let alert_ok = "Ok"
    static let alert_cancel = "Cancel"
}

struct LocalizedString {
    static let calculate_bill = NSLocalizedString("Calculate_tip", comment: "Calculate tip")
    static let textField_placeholder = NSLocalizedString("Enter_value", comment: "Enter value")
    static let textField_hint = NSLocalizedString("Input_bill_value", comment: "Input the bill value")
    static let tip_value_hint = NSLocalizedString("Tip_value", comment: "Tip value")
    static let total_value_hint = NSLocalizedString("Total_value_tip", comment: "Total value, tip plus initial value")
    static let clear_value_button_title = NSLocalizedString("Clear_values", comment: "CLEAR VALUES")
    
    static let no_value_to_be_saved = NSLocalizedString("No_value_to_be_saved", comment: "No value to be saved!")
    static let initial_bill = NSLocalizedString("initial_bill", comment: "initial bill")
}
