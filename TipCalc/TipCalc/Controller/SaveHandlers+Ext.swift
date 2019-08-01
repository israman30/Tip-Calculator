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
        guard let input = valueInput.text,
              let tip = tipValue.text,
              let total = totalValue.text else { return }
        if input.isEmpty {
            AlertController.alert(self, title: "😵", message: "Enter a value")
        } else {
            saveToDB(input: input, tip: tip, total: total)
        }
        valueInput.resignFirstResponder()
        handleResetFields()
    }
    
    func saveToDB(input: String, tip: String, total: String) {
        
        let bill = Bill(context: PersistanceServices.context)
        
        bill.input = "$\(input) initial bill"
        bill.tip = "\(tip) tip"
        bill.total = "\(total) total"
        bill.date = setDate()
        
        PersistanceServices.saveContext()
        bills.append(bill)
        tableView.reloadData()
    }
    
    func setDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: Date())
    }
    
    

}
