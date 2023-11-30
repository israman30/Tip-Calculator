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
        navigationItem.title = LocalizedString.calculate_bill
        
        let pin = UIImageView(image: UIImage(systemName: Constant.pin_circle))
        pin.tintColor = .black
        let pinView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        pinView.isAccessibilityElement = true
        pinView.accessibilityHint = Constant.pin_icon
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
        
        view.addSubview(mainScrollView)
        mainScrollView.contentSize = .init(width: view.bounds.width, height: view.bounds.height)
        mainScrollView.frame = view.bounds
        mainScrollView.isUserInteractionEnabled = true
        
//        mainScrollView.addSubview(containerView)
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            mainScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        containerView.backgroundColor = .yellow
        
        mainScrollView.addSubViews(valueInput, bottomView)
        
        valueInput.anchor(
            top: mainScrollView.safeAreaLayoutGuide.topAnchor,
            left: mainScrollView.leftAnchor,
            bottom: nil,
            right: mainScrollView.rightAnchor,
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
        tipLabel.text = Constant.tip
        tipLabel.textAlignment = .right
        tipLabel.textColor = .lightGray
        tipLabel.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        
        let totalLabel = UILabel()
        totalLabel.text = Constant.total
        totalLabel.textAlignment = .right
        totalLabel.textColor = .lightGray
        totalLabel.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        
        let splitLabel = UILabel()
        splitLabel.text = Constant.split_bill
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
        
        mainScrollView.addSubViews(stackView, segment)

        stackView.anchor(top: bottomView.bottomAnchor, left: bottomView.leftAnchor, bottom: nil, right: bottomView.rightAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 280))
        
        segment.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: stackView.rightAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 35))
        
        resetButton()
    }
    
    // MARK: - set the dynamic components
    private func resetButton() {
        mainScrollView.addSubViews(clearValuesButton, tableView)
        
        clearValuesButton.anchor(top: segment.bottomAnchor, left: segment.leftAnchor, bottom: nil, right: segment.rightAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 35))
        
        tableView.anchor(top: clearValuesButton.bottomAnchor, left: clearValuesButton.leftAnchor, bottom: view.bottomAnchor, right: clearValuesButton.rightAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    
}


