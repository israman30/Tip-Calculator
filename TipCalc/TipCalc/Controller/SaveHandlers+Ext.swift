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
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
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
            toastMessage.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    self.toastMessage.view.alpha = 1
                    self.toastMessage.view.transform = .identity
                }, completion: nil)
            }
        }
        saveViewModel?.displayToast(toastMessage.view)
        
    }
    
    /// `Accessibility announcement when bill is added`
    func displayAccessibilityToastMessage() {
        if saveViewModel?.isTotastVisible == true {
            UIAccessibility.post(notification: .announcement, argument: NSLocalizedString("Bill saved!", comment: "VoiceOver announcement when bill is saved"))
        }
    }
}


