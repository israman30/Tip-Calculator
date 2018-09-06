//
//  SettingDataSource+Delegate+Ext.swift
//  TipCalculator
//
//  Created by Israel Manzo on 9/6/18.
//  Copyright © 2018 Israel Manzo. All rights reserved.
//

import UIKit

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Delegates functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cell, for: indexPath) as! SettingsTableViewCell
        let lastBill = bills[indexPath.row]
        cell.lastTotalBillLbl.text = lastBill
        return cell
    }
}

