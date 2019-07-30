//
//  MainController.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/29/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

struct Bill {
    let input: String
    let tip: String
    let total: String
}

class MainController: UIViewController {
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 100
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "Calculate tip"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveBill))
        setMainView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BillCell.self, forCellReuseIdentifier: "cell")
        print(bills)
        
        
    }
    
    @objc func handleSaveBill(){
        print(123)
        guard let initialBill = valueInput.text,
              let tip = tipValue.text,
              let total = totalValue.text else { return }
        let newBill = Bill(input: initialBill, tip: tip, total: total)
        bills.append(newBill)
        tableView.reloadData()
        print(bills)
//        guard let input = valueInput.text,
//              let tip = tipValue.text,
//              let total = totalValue.text else { return }
//
//        if input.isEmpty || tip.isEmpty || total.isEmpty {
//            AlertController.alert(self, title: "⚔️", message: "Save valid values")
//        } else {
//
//            let savedBill = Bill(input: "Bill: $\(input)", tip: "Tip: \(tip)", total: "Total: \(total)")
//
//            bills.append(savedBill)
//        }
        
    }
    
    let segment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["18%", "20%", "25%"])
        sc.selectedSegmentIndex = 0
        sc.tintColor = .darkGray
        sc.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        return sc
    }()
    
    


}

extension MainController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BillCell
        cell.bills = bills[indexPath.row]
//        cell?.textLabel?.text = bills[indexPath.row].input
        return cell
    }
}
