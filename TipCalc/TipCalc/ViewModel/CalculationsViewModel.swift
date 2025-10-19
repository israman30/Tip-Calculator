//
//  MainViewModel.swift
//  TipCalc
//
//  Created by Israel Manzo on 8/12/21.
//  Copyright © 2021 Israel Manzo. All rights reserved.
//

import UIKit
//["10%", "15%", "20%", "25%"]
enum Percentages: Int, CaseIterable {
    case ten_percent = 0
    case fifteen_percent = 1
    case twienty_percent = 2
    case twientyfive_percent = 3
    
    var description: String {
        switch self {
        case .ten_percent:
            return "10%"
        case .fifteen_percent:
            return "15%"
        case .twienty_percent:
            return "20%"
        case .twientyfive_percent:
            return "25%"
        }
    }
}

protocol ViewModelBillCalculationsProtocol {
    func calculateTip(with valueInput: UITextField, segment: UISegmentedControl, tipValue: UILabel, totalValue: UILabel)
    func reset(valueInput: UITextField, tipValue: UILabel, totalValue: UILabel, totalByPerson: UILabel, peopleQuantity: UILabel)
    func splitBiil(people: UILabel, bill: Double, totalByPerson: UILabel)
}

final class CalculationsViewModel: ViewModelBillCalculationsProtocol {
    var mainBill: Double = 0.0
    
    // MARK: - Core Tip Calculation Logic
    // Calculates tip amount and total bill based on user input and selected percentage
    // Updates UI labels in real-time as user types or changes percentage
    // Handles invalid input gracefully by resetting to $0.00
    func calculateTip(with valueInput: UITextField, segment: UISegmentedControl, tipValue: UILabel, totalValue: UILabel) {
        let tipPerc = [0.10, 0.15, 0.20, 0.25]
        
        guard let input = valueInput.text else { return }
        
        let bill =  Double(input)
        
        if let bill = bill {
            
            let tip = bill * tipPerc[segment.selectedSegmentIndex]
            let total = bill + tip
            mainBill = total
            
            tipValue.text = String(format: "$%.2f", tip).currencyInputFormatting()
            totalValue.text = String(format: "$%.2f", total).currencyInputFormatting()
        } else {
            tipValue.text = Constant.zero
            totalValue.text = Constant.zero
        }
        
    }
    
    // MARK: - Reset All Calculation Fields
    // Clears all input fields and resets calculations to default state
    // Called when user taps clear button or after successful save operation
    func reset(valueInput: UITextField, tipValue: UILabel, totalValue: UILabel, totalByPerson: UILabel, peopleQuantity: UILabel) {
        valueInput.text = ""
        tipValue.text = Constant.zero
        totalValue.text = Constant.zero
        peopleQuantity.text = "1x"
        totalByPerson.text = Constant.zero
        mainBill = 0
    }
    
    // MARK: - Bill Splitting Logic
    // Calculates per-person amount when splitting bill among multiple people
    // Updates UI to show split information and per-person cost
    func splitBiil(people: UILabel, bill: Double, totalByPerson: UILabel) {
        people.text = "\(Int(bill))x"
        people.accessibilityLabel = "\(Int(bill)) people"
        totalByPerson.text = String(format: "$%.2f", (mainBill / bill)).currencyInputFormatting()
    }
}

extension String {
    
    /// Formats text input as currency with proper symbol and decimal places
    /// Handles regex-based number extraction and locale-aware formatting
    func currencyInputFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(
            in: amountWithPrefix,
            options: NSRegularExpression.MatchingOptions(rawValue: 0),
            range: NSMakeRange(0, self.count),
            withTemplate: ""
        )
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}
