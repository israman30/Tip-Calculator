//
//  SaveViewModel.swift
//  TipCalc
//
//  Created by Israel Manzo on 8/12/21.
//  Copyright © 2021 Israel Manzo. All rights reserved.
//

import UIKit
import CoreData

protocol ViewModelBillImplementationProtocol {
    func fetchItems()
    func save(_ vc: UIViewController, valueInput: UITextField, tipValue: UILabel, totalValue: UILabel, splitTotal: UILabel?, splitPeopleQuantity: UILabel?)
}

class SaveViewModel: ViewModelBillImplementationProtocol {
    
    var bills = [Bill]()
    
    // MARK: - Handler checks for input before saves on db
    // saveToBD function handles to save input after input is authentificated
    // After input is saved into db, the fields are reseted and keyboard dismissed
    func save(_ vc: UIViewController, valueInput: UITextField, tipValue: UILabel, totalValue: UILabel, splitTotal: UILabel?, splitPeopleQuantity: UILabel?) {
        guard let input = valueInput.text,
              let tip = tipValue.text,
              let total = totalValue.text else { return }
        guard let splitTotal = splitTotal?.text, let splitPeopleQuantity = splitPeopleQuantity?.text else { return }
        if input.isEmpty {
            AlertController.alert(vc, title: "😵", message: NSLocalizedString("No_value_to_be_saved", comment: "Blank entry. No information worth saving."))
        } else {
            saveToDB(input: input, tip: tip, total: total, splitTotal: splitTotal, splitPeopleQuantity: splitPeopleQuantity)
        }
        valueInput.resignFirstResponder()
    }
    
    // MARK: - This function saves into db input and calculations using context
    // Functino uses Core Data Persistance class to save object created by the context
    // After the object is saved, is appended to an array container
    // MARK - NOTE: PersistanceServices.saveContext() is always called in the AppDelegate when application is terminated
    private func saveToDB(input: String, tip: String, total: String, splitTotal: String?, splitPeopleQuantity: String?) {
        
        let bill = Bill(context: PersistanceServices.context)
        
        bill.input = "$\(input) \(NSLocalizedString("initial_bill", comment: "initial bill"))"
        bill.tip = "\(tip) tip"
        bill.total = "\(total) total"
        bill.date = TimeString.setDate()
        bill.splitPeopleQuantity = splitPeopleQuantity
        bill.splitTotal = splitTotal
        
        PersistanceServices.saveContext()
        bills.append(bill)
    }
    
    // MARK: - This function fetch data saved from db using the context the assigned to the array container to be display it in the UI
    func fetchItems() {
        let fetchRequest: NSFetchRequest<Bill> = Bill.fetchRequest()
        do {
            let savedBills = try PersistanceServices.context.fetch(fetchRequest)
            bills = savedBills
        } catch let error {
            print("Error fetching info from CDDB", error.localizedDescription)
        }
    }
    
}
