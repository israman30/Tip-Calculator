//
//  SaveHandlers+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit



extension Notification.Name {
    static let didSaveBill: Notification.Name = .init("didSaveBill")
}

extension MainController {
    @objc func handleSaveBill() {
        saveViewModel?.save(
            self,
            valueInput: valueInput,
            tipValue: tipValue,
            totalValue: totalValue,
            splitTotal: splitTotal,
            splitPeopleQuantity: splitPeopleQuantity
        )
        handleResetFields()
        
        if saveViewModel?.isTotastVisible == true {
            displayAccessibilityToastMessage()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.toastMessage.view.alpha = 1
                }, completion: nil)
            }
        }
                           
        saveViewModel?.displayToast(toastMessage.view)
        
        if let billsCount = saveViewModel?.bills.count {
            NotificationCenter.default.post(name: .didSaveBill, object: nil, userInfo: ["billsCount": billsCount])
        }
    }
    
    /// `Accessibility announcement when bill is added`
    func displayAccessibilityToastMessage() {
        if saveViewModel?.isTotastVisible == true {
            UIAccessibility.post(notification: .announcement, argument: toastMessage)
        }
    }
}

