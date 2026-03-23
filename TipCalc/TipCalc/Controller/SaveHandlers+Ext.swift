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
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
        
        saveViewModel?.save(
            self,
            valueInput: valueInput,
            tipValue: tipValue,
            totalValue: totalValue,
            splitTotal: splitTotal,
            splitPeopleQuantity: splitPeopleQuantity,
            category: selectedCategory
        )
        handleResetFields()
        
        if saveViewModel?.isTotastVisible == true {
            displayAccessibilityToastMessage()
            toastMessage.view.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            toastMessage.view.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.6, options: .curveEaseOut, animations: {
                    self.toastMessage.view.alpha = 1
                    self.toastMessage.view.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2) {
                        self.toastMessage.view.transform = .identity
                    }
                })
            }
        }
        saveViewModel?.displayToast(toastMessage.view)
        
    }
    
    /// `Accessibility announcement when bill is added`
    func displayAccessibilityToastMessage() {
        if saveViewModel?.isTotastVisible == true {
            UIAccessibility.post(
                notification: .announcement,
                argument: LocalizedString.billSaved
            )
        }
    }
}


