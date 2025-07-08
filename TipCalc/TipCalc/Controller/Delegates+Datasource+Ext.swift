//
//  Delegates+Datasource+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

extension MainController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if saveViewModel?.sortedBills.count == 0 {
            tableView.tableViewEmpty(with: LocalizedString.emptyTableViewTitle, message: LocalizedString.emptyTableViewMessage)
        } else {
            tableView.restore()
        }
        return saveViewModel?.sortedBills.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId.cell.rawValue) as! BillCell
        guard let sortedBills = saveViewModel?.sortedBills else { return cell }
        cell.configure(bill: sortedBills[indexPath.row])
        return cell
    }
    
    // MARK: - Method delete from db with context then save what still in db, when user swipe editingStyle.delete cell using indexPath
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let sortedBills = saveViewModel?.sortedBills.sorted(by: { $0.date ?? "" < $1.date ?? "" }) else { return }
            
            let billToDelete = sortedBills[indexPath.row]
            
            // Remove from the original bills array
            if let index = saveViewModel?.bills.firstIndex(of: billToDelete) {
                saveViewModel?.bills.remove(at: index)
            }
            
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            PersistanceServices.context.delete(billToDelete)
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

