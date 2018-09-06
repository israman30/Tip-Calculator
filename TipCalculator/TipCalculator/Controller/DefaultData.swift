//
//  DefaultData.swift
//  TipCalculator
//
//  Created by Israel Manzo on 9/6/18.
//  Copyright © 2018 Israel Manzo. All rights reserved.
//

import UIKit

extension ViewController {
    
    func saveUserDefaultData(){
        let userDefaults = UserDefaults.standard
        userDefaults.set(totalLbl.text, forKey: "tips")
        userDefaults.synchronize()
        billTxt.text = ""
        saveAlert()
    }
    
    func saveAlert(){
        AlertController.alert(self, title: "Good Job!", message: "Your last bill had been saved")
    }
}
