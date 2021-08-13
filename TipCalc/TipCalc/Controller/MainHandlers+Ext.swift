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
        mainViewModel.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue)
    }
    
    @objc func handleResetFields(){
        mainViewModel.reset(valueInput: valueInput, tipValue: tipValue, totalValue: totalValue)
    }
    
}

