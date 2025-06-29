//
//  SaveHandlers+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

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
        
        // Update table view with animation to show new item at top
        tableView.reloadData()
        updateTableViewHeight()
        
        // Scroll to top to show the new item
        if let sortedBills = saveViewModel?.sortedBills, !sortedBills.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
        if saveViewModel?.isTotastVisible == true {
            displayAccessibilityToastMessage()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.toastMessage.view.alpha = 1
                }, completion: nil)
            }
        }
                           
        saveViewModel?.displayToast(toastMessage.view)
    }
    
    /// `Accessibility announcement when bill is added`
    func displayAccessibilityToastMessage() {
        if saveViewModel?.isTotastVisible == true {
            UIAccessibility.post(notification: .announcement, argument: toastMessage)
        }
    }
}

