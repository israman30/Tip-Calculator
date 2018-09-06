//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Israel Manzo on 7/26/17.
//  Copyright © 2017 Israel Manzo. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var userDefaults = UserDefaults.standard
    
    var bills = [String]()
    
    var values = [String]()
    
    let cell = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        bills = [userDefaults.string(forKey: "tips")!]
        tableView.reloadData()
    }
    
}


