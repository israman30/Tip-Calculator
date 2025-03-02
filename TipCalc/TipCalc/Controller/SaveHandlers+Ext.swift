//
//  SaveHandlers+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

extension MainController {
    
    @objc func handleSaveBill() {
        saveViewModel?.save(
            self,
            valueInput: valueInput,
            tipValue: tipValue,
            totalValue: totalValue,
            splitTotal: splitTotal,
            splitPeopleQuantity: splitPeopleQuantity
        )
        handleResetFields()
        tableView.reloadData()
    }

}

