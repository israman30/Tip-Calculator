//
//  SaveHandlers+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

extension MainController {
    
    // MARK: - Handler checks for input before saves on db
    // saveToBD function handles to save input after input is authentificated
    // After input is saved into db, the fields are reseted and keyboard dismissed
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
    
    // MARK: - This function saves into db input and calculations using context
    // Functino uses Core Data Persistance class to save object created by the context
    // After the object is saved, is appended to an array container
    // MARK - NOTE: PersistanceServices.saveContext() is always called in the AppDelegate when application is terminated
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
    
    // MARK: - setDate function returns a Date of type String that is assigned to the date object created by the context
    func setDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: Date())
    }
    
    

}
