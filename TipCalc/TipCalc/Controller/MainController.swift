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
    }
    
    var bills = [Bill]()
    
    @objc func handleSaveBill(){
        let detailController = DetailController()
        
        guard let input = valueInput.text,
              let tip = tipValue.text,
              let total = totalValue.text else { return }
        let savedBill = Bill(input: "Bill: $\(input)", tip: "Tip: \(tip)", total: "Total: \(total)")
        
        bills.append(savedBill)
        detailController.bill = bills
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    let segment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["18%", "20%", "25%"])
        sc.selectedSegmentIndex = 0
        sc.tintColor = .darkGray
        sc.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        return sc
    }()


}

