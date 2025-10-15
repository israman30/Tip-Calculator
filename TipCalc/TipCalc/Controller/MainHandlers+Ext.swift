//
//  MainHandlers+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

extension MainController {
    @objc func changeValue() {
        calculationsViewModel?.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue)
    }
    
    @objc func handleResetFields() {
        calculationsViewModel?.reset(
            valueInput: valueInput,
            tipValue: tipValue,
            totalValue: totalValue,
            totalByPerson: splitTotal,
            peopleQuantity: splitPeopleQuantity
        )
    }
    
    @objc func changeStepperQuantity() {
        guard let input = valueInput.text else { return }
        guard !input.isEmpty else {
            return
        }
        calculationsViewModel?.splitBiil(people: splitPeopleQuantity, bill: splitStepper.value, totalByPerson: splitTotal)
    }
}

