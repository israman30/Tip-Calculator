//
//  Delegates+Datasource+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

extension MainController: UITableViewDataSource, UITableViewDelegate {
    
    func tableViewHandlers(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.register(BillCell.self, forCellReuseIdentifier: CellId.cell.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId.cell.rawValue) as! BillCell
        cell.bills = bills[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = bills.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            PersistanceServices.context.delete(index)
            PersistanceServices.saveContext()
        } else {
            tableView.reloadData()
        }
    }
}
