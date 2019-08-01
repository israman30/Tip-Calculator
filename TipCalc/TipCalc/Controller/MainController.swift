//
//  MainController.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/29/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit
import CoreData

class MainController: UIViewController {
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 100
        tv.showsVerticalScrollIndicator = false
        tv.allowsSelection = false
        return tv
    }()
    
    var bills = [Bill]()
    
    let valueInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter value"
        tf.font = UIFont.systemFont(ofSize: 30)
        tf.textAlignment = .right
        tf.isUserInteractionEnabled = true
        tf.keyboardType = .decimalPad
        tf.addTarget(self, action: #selector(changeValue), for: .editingChanged)
        return tf
    }()
    
    let bottomView = UIView()
    
    let tipValue: UILabel = {
        let label = UILabel()
        label.text = "$0.0"
        label.font = UIFont.systemFont(ofSize: 50)
        label.textAlignment = .right
        return label
    }()
    
    let totalValue: UILabel = {
        let label = UILabel()
        label.text = "$0.0"
        label.font = UIFont.systemFont(ofSize: 50)
        label.textAlignment = .right
        return label
    }()
    
    let segment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["18%", "20%", "25%"])
        sc.selectedSegmentIndex = 0
        sc.tintColor = .darkGray
        sc.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbar()
        setMainView()
        tableViewHandlers()
        fetchRequestFromDB()
    }
    
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


