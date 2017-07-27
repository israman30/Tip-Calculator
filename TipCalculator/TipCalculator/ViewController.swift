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
    
    // MARK: - Tip calculation function
    func tipCalculations(){
        let tipPerc = [0.18, 0.20, 0.25]
        
        let bill =  Double(billTxt.text!) ?? 0
        let tip = bill * tipPerc[tipPercentageCalculator.selectedSegmentIndex]
        let total = bill + tip
        
        // Display the value of the tip and the total with two decimal digits
        tipLbl.text = String(format: "$%.2f", tip)
        totalLbl.text = String(format: "$%.2f", total)
    }
    
    // MARK: - We saving the last bill
    @IBAction func saveTip(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(totalLbl.text, forKey: "tips")
        userDefaults.synchronize()
        billTxt.text = ""
        print(userDefaults)
        
    }
    
}

