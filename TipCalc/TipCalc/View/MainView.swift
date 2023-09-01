//
//  MainView.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

extension MainController {
    
    // MARK: - Keyboard dismiss when touch view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Navbar holds a icon, when user taps a UITapGesture that triggers a save fcuntion
    func setNavbar() {
        navigationItem.title = NSLocalizedString("Calculate_tip", comment: "Calculate tip")
        
        let pin = UIImageView(image: UIImage(systemName: "pin.circle"))
        pin.tintColor = .black
        let pinView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        pinView.isAccessibilityElement = true
        pinView.accessibilityHint = "Pin Icon"
        pinView.accessibilityTraits.insert(.button)
        
        pinView.addSubViews(pin)
        pin.frame = pinView.frame
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pinView)
        
        pin.isUserInteractionEnabled = true
        pin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSaveBill)))
    }
    
    // MARK: - Set the MainView components
    func setMainView() {
        view.backgroundColor = .white
        bottomView.backgroundColor = .lightGray
        
        view.addSubViews(valueInput, bottomView)
        
        valueInput.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: nil,
            right: view.rightAnchor,
            padding: .init(top: 10, left: 20, bottom: 0, right: 20),
            size: .init(width: 0, height: 50)
        )
        
        bottomView.anchor(
            top: valueInput.bottomAnchor,
            left: valueInput.leftAnchor,
            bottom: nil,
            right: valueInput.rightAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0),
            size: .init(width: 0, height: 2)
        )
        
        outputValues()
    }
    
    // MARK: - Set the output components
    private func outputValues() {
        
        let tipLabel = UILabel()
        tipLabel.text = "Tip"
        tipLabel.textAlignment = .right
        tipLabel.textColor = .lightGray
        tipLabel.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        
        let totalLabel = UILabel()
        totalLabel.text = "Total"
        totalLabel.textAlignment = .right
        totalLabel.textColor = .lightGray
        totalLabel.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        
        let splitLabel = UILabel()
        splitLabel.text = "Split bill"
        splitLabel.textAlignment = .left
        splitLabel.textColor = .lightGray
        splitLabel.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        
        let tipStackView = UIStackView(arrangedSubviews: [tipLabel, tipValue])
        tipStackView.axis = .horizontal
        let totalpStackView = UIStackView(arrangedSubviews: [totalLabel, totalValue])
        totalpStackView.axis = .horizontal
        let splitValuesStackView = UIStackView(arrangedSubviews: [splitTotal, splitPeopleQuantity])
        splitValuesStackView.axis = .horizontal
        splitValuesStackView.spacing = 25
        let splitBillStackView = UIStackView(arrangedSubviews: [splitLabel, UIView(), splitValuesStackView])
        splitBillStackView.axis = .horizontal
        
        let stackView = UIStackView(arrangedSubviews:
            [tipStackView, totalpStackView, splitBillStackView, splitStepper]
        )
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 0
        
        view.addSubViews(stackView, segment)

        stackView.anchor(top: bottomView.bottomAnchor, left: bottomView.leftAnchor, bottom: nil, right: bottomView.rightAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 280))
        
        segment.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: stackView.rightAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 35))
        
        resetButton()
    }
    
    // MARK: - set the dynamic components
    private func resetButton() {
        view.addSubViews(clearValuesButton, tableView)
        
        clearValuesButton.anchor(top: segment.bottomAnchor, left: segment.leftAnchor, bottom: nil, right: segment.rightAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 35))
        
        tableView.anchor(top: clearValuesButton.bottomAnchor, left: clearValuesButton.leftAnchor, bottom: view.bottomAnchor, right: clearValuesButton.rightAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    
}


