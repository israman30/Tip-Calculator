//
//  MainHandlers+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

extension MainController {
    
    @objc func changeValue() {
        calculateTip()
    }
    
    // MARK: - This function calculate the entry with the percentage picked by the user, by defult the percentage is 18%
    // Percentage is picked by the segmented controller selected index then is added to the entry
    // guard statement check if the entry has a valid value if not, display default value of $0.0
    func calculateTip(){
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
    @objc func handleResetFields(){
        valueInput.text = ""
        tipValue.text = "$0.0"
        totalValue.text = "$0.0"
    }
    
}

