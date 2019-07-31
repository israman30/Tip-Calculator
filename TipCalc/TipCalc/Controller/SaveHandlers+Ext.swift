//
//  SaveHandlers+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

extension MainController {
    
    @objc func handleSaveBill(){
        
        guard let initialBill = valueInput.text,
            let tip = tipValue.text,
            let total = totalValue.text else { return }
        saveBill(initialBill: initialBill, tip: tip, total: total)
    }
    
    func saveBill(initialBill: String, tip: String, total: String) {
        
        if initialBill.isEmpty || tip.isEmpty || total.isEmpty {
            AlertController.alert(self, title: "⚔️", message: "Save valid values")
        } else {
            let newBill = Bill(
                input: "$\(initialBill): initial bill",
                tip: tip + ": tip",
                total: total + ": total bill"
            )
            bills.append(newBill)
            tableView.reloadData()
            valueInput.resignFirstResponder()
        }
    }
    
    

}
