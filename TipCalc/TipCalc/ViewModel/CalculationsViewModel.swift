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
    // MARK: - This function calculate the entry with the percentage picked by the user, by defult the percentage is 18%
    // Percentage is picked by the segmented controller selected index then is added to the entry
    // guard statement check if the entry has a valid value if not, display default value of $0.0
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
    
    // MARK: - Reset the fields when user needs to reset it or/and after entry is saved into db
    func reset(valueInput: UITextField, tipValue: UILabel, totalValue: UILabel, totalByPerson: UILabel, peopleQuantity: UILabel) {
        valueInput.text = ""
        tipValue.text = Constant.zero
        totalValue.text = Constant.zero
        peopleQuantity.text = "1x"
        totalByPerson.text = Constant.zero
        mainBill = 0
    }
    
    func splitBiil(people: UILabel, bill: Double, totalByPerson: UILabel) {
        people.text = "\(Int(bill))x"
        people.accessibilityLabel = "\(Int(bill)) people"
        totalByPerson.text = String(format: "$%.2f", (mainBill / bill)).currencyInputFormatting()
    }
}

extension String {

/// formatting text for currency textField
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
