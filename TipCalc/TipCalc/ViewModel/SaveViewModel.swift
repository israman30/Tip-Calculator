//
//  SaveViewModel.swift
//  TipCalc
//
//  Created by Israel Manzo on 8/12/21.
//  Copyright © 2021 Israel Manzo. All rights reserved.
//

import UIKit
import CoreData

/// `ViewModelBillImplementationProtocol` Implementation for Saving data
protocol ViewModelBillImplementationProtocol {
    func fetchItems()
    func save(_ vc: UIViewController, valueInput: UITextField, tipValue: UILabel, totalValue: UILabel, splitTotal: UILabel?, splitPeopleQuantity: UILabel?)
}

/// `SaveBillProtocol` Implementation for Saving data in local storage
protocol SaveBillProtocol {
    var bills: [Bill] { get set }
    func savingInLocalstorage(with input: String, tip: String, total: String, splitTotal: String?, splitPeopleQuantity: String?)
}

final class SaveViewModel: ViewModelBillImplementationProtocol, SaveBillProtocol {
    
    var bills = [Bill]()
    var isTotastVisible: Bool = false
    
    // MARK: - Sorted Bills Property
    // Returns bills sorted by date (newest first) for display in table view
    var sortedBills: [Bill] {
        return bills.sorted(by: { $0.date ?? "" < $1.date ?? "" })
    }
    
    // MARK: - Save Bill Calculation
    // Validates input before saving to Core Data
    // Shows alert if no valid input, otherwise saves and shows success feedback
    // Dismisses keyboard after save operation
    func save(_ vc: UIViewController, valueInput: UITextField, tipValue: UILabel, totalValue: UILabel, splitTotal: UILabel?, splitPeopleQuantity: UILabel?) {
        guard let input = valueInput.text,
              let tip = tipValue.text,
              let total = totalValue.text else { return }
        guard let splitTotal = splitTotal?.text, let splitPeopleQuantity = splitPeopleQuantity?.text else { return }
        
        if input.isEmpty {
            AlertController.alert(vc, title: "😵", message: LocalizedString.no_value_to_be_saved)
        } else {
            savingInLocalstorage(with: input, tip: tip, total: total, splitTotal: splitTotal, splitPeopleQuantity: splitPeopleQuantity)
            isTotastVisible = true
        }
        valueInput.resignFirstResponder()
    }
    
    func displayToast(_ view: UIView) {
        if isTotastVisible {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                    view.alpha = 0.0
                }, completion: nil)
            }
        }
        
        isTotastVisible = false
    }
    
    // MARK: - Core Data Persistence
    // Creates new Bill entity and saves to Core Data with all calculation details
    // Adds timestamp and split information if applicable
    // Appends to local array for immediate UI updates
    func savingInLocalstorage(with input: String, tip: String, total: String, splitTotal: String?, splitPeopleQuantity: String?) {
        let bill = Bill(context: PersistanceServices.context)
        bill.input = "$\(input) \(LocalizedString.initial_bill)"
        bill.tip = "\(tip) tip"
        bill.total = "\(total) total"
        bill.date = TimeString.setDate()
        bill.splitPeopleQuantity = splitPeopleQuantity
        bill.splitTotal = splitTotal
        
        PersistanceServices.saveContext()
        bills.append(bill)
    }
    
    // MARK: - Fetch Saved Bills
    // Retrieves all saved bills from Core Data and updates local array
    // Handles fetch errors gracefully with console logging
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
