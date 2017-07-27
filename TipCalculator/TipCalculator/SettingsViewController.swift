//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Israel Manzo on 7/26/17.
//  Copyright © 2017 Israel Manzo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var userDefaults = UserDefaults.standard
    
    var bills = String()
    
    var values = [String]()
    
    let cell = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Mark: - We use a conditional to check if is data or not
        if bills == "" {
            
            bills = userDefaults.string(forKey: "tips")!
            values.append(bills)
            tableView.reloadData()
            
        } else {
            print("Nothign here!")
        }
    }
    
    // MARK: - Delegates functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cell, for: indexPath) as! SettingsTableViewCell
        
        let lastBill = values[indexPath.row]
        
        cell.lastTotalBillLbl.text = lastBill
        
        return cell
    }

}
