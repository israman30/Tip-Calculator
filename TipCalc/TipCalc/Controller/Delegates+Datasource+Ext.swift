//
//  Delegates+Datasource+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

extension MainController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - TableView delegate and datasource + cell registration
    func tableViewHandlers() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BillCell.self, forCellReuseIdentifier: CellId.cell.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveViewModel?.bills.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId.cell.rawValue) as! BillCell
        cell.configure(bill: saveViewModel?.bills[indexPath.row])
        return cell
    }
    
    // MARK: - Method delete from db with context then save what still in db, when user swipe editingStyle.delete cell using indexPath
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let index = saveViewModel?.bills.remove(at: indexPath.row) else { return }
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            PersistanceServices.context.delete(index)
            PersistanceServices.saveContext()
        } else {
            tableView.reloadData()
        }
    }
    
    // MARK: - Find the way for display the tableView when tap in a arrow row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//        present(SplitViewController(), animated: true)
    }
}
