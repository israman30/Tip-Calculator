//
//  CalculationsMethod+Ext.swift
//  TipCalculator
//
//  Created by Israel Manzo on 9/6/18.
//  Copyright © 2018 Israel Manzo. All rights reserved.
//

import UIKit

extension ViewController {
    
    // MARK: - Tip calculation function
    func tipCalculations(){
        let tipPerc = [0.18, 0.20, 0.25]
        
        let bill =  Double(billTxt.text!) ?? 0
        let tip = bill * tipPerc[tipPercentageCalculator.selectedSegmentIndex]
        let total = bill + tip
        
        // Display the value of the tip and the total with two decimal digits
        tipLbl.text = String(format: "$%.2f", tip)
        totalLbl.text = String(format: "$%.2f", total)
    }
}
