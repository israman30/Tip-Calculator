//
//  ViewController.swift
//  TipCalculator
//
//  Created by Israel Manzo on 7/25/17.
//  Copyright © 2017 Israel Manzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var billTxt: UITextField!
    @IBOutlet weak var tipPercentageCalculator: UISegmentedControl!
    @IBOutlet weak var viewOne: UIView!
    
    var tips = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    // MARK: - End tapping after enter bill info
    @IBAction func endTap(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func calculateTip(_ sender: Any) {
        tipCalculations()
    }
    
    // MARK: - We saving the last bill
    @IBAction func saveTip(_ sender: Any) {
        saveUserDefaultData()
    }
    
}





