//
//  DB+FetchRequest+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 8/1/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import Foundation
import CoreData

extension MainController {
    
    func fetchRequestFromDB() {
        
        let fetchRequest: NSFetchRequest<Bill> = Bill.fetchRequest()
        
        do {
            let savedBills = try PersistanceServices.context.fetch(fetchRequest)
            bills = savedBills
            tableView.reloadData()
        } catch let error {
            print("Error", error.localizedDescription)
        }
    }
    
}

