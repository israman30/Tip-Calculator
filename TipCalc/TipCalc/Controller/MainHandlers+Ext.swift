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
            triggerCalculationHaptic()
        }
    }
    
    /// Light haptic when calculation produces valid result; throttled to avoid rapid firing during typing
    func triggerCalculationHaptic() {
        guard Date().timeIntervalSince(lastCalculationHapticTime) >= calculationHapticThrottle else { return }
        lastCalculationHapticTime = Date()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
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
        triggerCalculationHaptic()
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

    @objc func handleCategoryTapped(_ sender: UIButton) {
        guard let title = sender.configuration?.title else { return }
        selectedCategory = title
        refreshCategoryChips()
    }

    @objc func handleAddCustomCategory() {
        let alert = UIAlertController(
            title: NSLocalizedString("Custom Category", comment: "Custom category alert title"),
            message: NSLocalizedString("Enter a custom tag for this bill", comment: "Custom category alert message"),
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("e.g. Coffee, Grocery", comment: "Custom tag placeholder")
            textField.autocapitalizationType = .words
        }
        alert.addAction(UIAlertAction(title: Constant.alert_cancel, style: .cancel))
        alert.addAction(UIAlertAction(title: Constant.alert_ok, style: .default) { [weak self] _ in
            guard let tag = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !tag.isEmpty else { return }
            CustomCategoryStorage.addTag(tag)
            self?.selectedCategory = tag
            self?.refreshCategoryChips()
        })
        present(alert, animated: true)
    }

    func refreshCategoryChips() {
        categoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let allCategories = BillCategory.predefinedCategories.map { $0.rawValue } + CustomCategoryStorage.tags
        for category in allCategories {
            let chip = categoryChip(for: category)
            categoryStackView.addArrangedSubview(chip)
        }
        let addCustomButton = addCustomCategoryButton()
        categoryStackView.addArrangedSubview(addCustomButton)
    }

    private func categoryChip(for title: String) -> UIButton {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.title = title
        config.baseForegroundColor = selectedCategory == title ? .white : .label
        config.background.backgroundColor = selectedCategory == title
            ? UIColor.systemTeal
            : UIColor.secondarySystemFill
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { _ in
            var attrs = AttributeContainer()
            attrs.font = .preferredFont(forTextStyle: .subheadline)
            return attrs
        }
        button.configuration = config
        button.addTarget(self, action: #selector(handleCategoryTapped(_:)), for: .touchUpInside)
        return button
    }

    private func addCustomCategoryButton() -> UIButton {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "plus.circle")
        config.title = NSLocalizedString("Custom", comment: "Add custom category")
        config.baseForegroundColor = .systemTeal
        config.background.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.12)
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        config.imagePadding = 4
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { _ in
            var attrs = AttributeContainer()
            attrs.font = .preferredFont(forTextStyle: .subheadline)
            return attrs
        }
        button.configuration = config
        button.addTarget(self, action: #selector(handleAddCustomCategory), for: .touchUpInside)
        return button
    }
}

