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
        let customPercent: Double? = isCustomTipSliderVisible ? Double(tipSlider.value) : nil
        calculationsViewModel?.calculateTip(with: valueInput, segment: segment, tipValue: tipValue, totalValue: totalValue, customTipPercent: customPercent)
        // Update split display so saved values (via nav bar button) reflect current tip/total
        if let input = valueInput.text, !input.isEmpty {
            calculationsViewModel?.splitBiil(people: splitPeopleQuantity, bill: splitStepper.value, totalByPerson: splitTotal)
        }
    }
    
    @objc func handleResetFields() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        calculationsViewModel?.reset(
            valueInput: valueInput,
            tipValue: tipValue,
            totalValue: totalValue,
            totalByPerson: splitTotal,
            peopleQuantity: splitPeopleQuantity
        )
        splitStepper.value = 1
        splitPeopleQuantity.text = "\(Int(splitStepper.value))x"
    }
    
    @objc func changeStepperQuantity() {
        guard let input = valueInput.text else { return }
        guard !input.isEmpty else {
            return
        }
        calculationsViewModel?.splitBiil(people: splitPeopleQuantity, bill: splitStepper.value, totalByPerson: splitTotal)
    }
    
    @objc func handleTipSliderValueChanged(_ sender: UISlider) {
        let intValue = Int(sender.value)
        sender.value = Float(intValue)
        tipSliderPercentLabel.text = "\(intValue)%"
        changeValue()
    }
    
    @objc func handleTipSliderTouchUp(_ sender: UISlider) {
        let intValue = Int(sender.value)
        UserDefaults.standard.set(intValue, forKey: Constant.savedCustomTipPercentKey)
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    @objc func handleTotalValueDoubleTap() {
        toggleCustomTipSlider()
    }
    
    private func toggleCustomTipSlider() {
        isCustomTipSliderVisible.toggle()
        tipSliderContainerView.isHidden = false
        
        let targetHeight: CGFloat = isCustomTipSliderVisible ? 44 : 0
        tipSliderHeightConstraint?.constant = targetHeight
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.tipSliderContainerView.alpha = self.isCustomTipSliderVisible ? 1 : 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            if !self.isCustomTipSliderVisible {
                self.tipSliderContainerView.isHidden = true
            }
        }
        
        if isCustomTipSliderVisible {
            tipSliderPercentLabel.text = "\(Int(tipSlider.value))%"
            changeValue()
        } else {
            changeValue()
        }
    }
    
    func setupTipSlider() {
        tipSlider.addTarget(self, action: #selector(handleTipSliderValueChanged(_:)), for: .valueChanged)
        tipSlider.addTarget(self, action: #selector(handleTipSliderTouchUp(_:)), for: [.touchUpInside, .touchUpOutside])
    }
    
    func setupTotalValueDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleTotalValueDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        totalValue.addGestureRecognizer(doubleTap)
        totalValue.accessibilityHint = "\(LocalizedString.total_value_hint). \(LocalizedString.total_value_double_tap_hint)."
    }
}

