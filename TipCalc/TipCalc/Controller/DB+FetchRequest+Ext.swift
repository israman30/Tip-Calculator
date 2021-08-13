//
//  DB+FetchRequest+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 8/1/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import Foundation
import CoreData

protocol FetchSavedBillsDelegate {
    func fetchItems()
}

extension MainController: FetchSavedBillsDelegate {
    
    // MARK: - This function fetch data saved from db using the context the assigned to the array container to be display it in the UI
    func fetchItems() {
        let fetchRequest: NSFetchRequest<Bill> = Bill.fetchRequest()
        
        do {
            let savedBills = try PersistanceServices.context.fetch(fetchRequest)
            saveViewModel.bills = savedBills
            tableView.reloadData()
        } catch let error {
            print("Error fetching info from CDDB", error.localizedDescription)
        }
    }
    
}


