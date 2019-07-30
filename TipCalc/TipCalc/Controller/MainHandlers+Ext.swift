//
//  MainHandlers+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

extension MainController {
    
    @objc func changeValue(){
        calculateTip()
    }
    
    func calculateTip(){
        let tipPerc = [0.18, 0.20, 0.25]
        
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
    
    @objc func handleResetFields(){
        valueInput.text = ""
        tipValue.text = "$0.0"
        totalValue.text = "$0.0"
    }
    
}

