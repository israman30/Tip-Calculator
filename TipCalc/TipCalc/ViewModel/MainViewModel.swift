//
//  MainViewModel.swift
//  TipCalc
//
//  Created by Israel Manzo on 8/12/21.
//  Copyright © 2021 Israel Manzo. All rights reserved.
//

import UIKit

class MainViewModel {
    
    // MARK: - This function calculate the entry with the percentage picked by the user, by defult the percentage is 18%
    // Percentage is picked by the segmented controller selected index then is added to the entry
    // guard statement check if the entry has a valid value if not, display default value of $0.0
    func calculateTip(with valueInput: UITextField, segment: UISegmentedControl, tipValue: UILabel, totalValue: UILabel) {
        let tipPerc = [0.15, 0.20, 0.25]
        
        guard let input = valueInput.text else { return }
        
        let bill =  Double(input)
        
        if let bill = bill {
            
            let tip = bill * tipPerc[segment.selectedSegmentIndex]
            let total = bill + tip
            
            tipValue.text = String(format: "$%.2f", tip)
            totalValue.text = String(format: "$%.2f", total)
        } else {
            tipValue.text = "$0.0"
            totalValue.text = "$0.0"
        }
    }
    
    // MARK: - Reset the fields when user needs to reset it or/and after entry is saved into db
    func reset(valueInput: UITextField, tipValue: UILabel, totalValue: UILabel) {
        valueInput.text = ""
        tipValue.text = "$0.0"
        totalValue.text = "$0.0"
    }
}
