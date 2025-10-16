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
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let appTitle = UILabel()
        appTitle.text = LocalizedString.calculate_bill
        appTitle.font = .preferredFont(forTextStyle: .title1)
        appTitle.sizeToFit()
        appTitle.accessibilityTraits.insert(.header)
        let leftTitle = UIBarButtonItem(customView: appTitle)
        if #available(iOS 26.0, *) {
            leftTitle.hidesSharedBackground = true
        } else {
            // Fallback on earlier versions
            // TODO: update earlier versions
        }
        navigationItem.leftBarButtonItem = leftTitle
        
        let pin = UIImageView(image: UIImage(systemName: Constant.pin_circle))
        let pinView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        pinView.isAccessibilityElement = true
        pinView.accessibilityHint = Constant.pin_icon
        pinView.accessibilityTraits.insert(.button)
        pinView.accessibilityHint = AccessibilityLabels.pintButtonHint
        
        pinView.addSubViews(pin)
        pin.frame = pinView.frame
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pinView)
        
        pin.isUserInteractionEnabled = true
        pin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSaveBill)))
    }
    
    // MARK: - Set the MainView components
    func setUI() {
        // Create scroll view as main container
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create content view for scroll view
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add scroll view to main view
        view.addSubview(scrollView)
        
        // Add content view to scroll view
        scrollView.addSubview(contentView)
        
        // Add all UI elements to content view instead of main view
        contentView.addSubViews(valueInput)
        
        // Setup scroll view constraints - Fix: Use safeAreaLayoutGuide for bottom
        scrollView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        
        // Setup content view constraints
        contentView.anchor(
            top: scrollView.topAnchor,
            left: scrollView.leftAnchor,
            bottom: scrollView.bottomAnchor,
            right: scrollView.rightAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        
        // Ensure content view width matches scroll view width
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        valueInput.anchor(
            top: contentView.topAnchor,
            left: contentView.leftAnchor,
            bottom: nil,
            right: contentView.rightAnchor,
            padding: .init(top: 10, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 50)
        )
        
        valueInput.addSubview(toastMessage.view)
        toastMessage.view.translatesAutoresizingMaskIntoConstraints = true
        toastMessage.view.anchor(
            top: valueInput.topAnchor,
            left: valueInput.leftAnchor,
            bottom: valueInput.bottomAnchor,
            right: valueInput.rightAnchor,
            padding: .init(top: 0, left: 0, bottom: 35, right: 0)
        )
        
        outputValues(contentView: contentView)
    }
    
    // MARK: - Set the output components
    private func outputValues(contentView: UIView) {
        let tipLabel = UILabel()
        tipLabel.text = Constant.tip
        tipLabel.textAlignment = .right
        tipLabel.textColor = .gray
        tipLabel.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        tipLabel.isAccessibilityElement = false
        
        let totalLabel = UILabel()
        totalLabel.text = Constant.total
        totalLabel.textAlignment = .right
        totalLabel.textColor = .gray
        totalLabel.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        totalLabel.isAccessibilityElement = false
        
        let splitLabel = UILabel()
        splitLabel.text = Constant.split_bill
        splitLabel.textAlignment = .left
        splitLabel.textColor = .gray
        splitLabel.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        splitLabel.isAccessibilityElement = false
        
        let tipStackView = UIStackView(arrangedSubviews: [tipLabel, tipValue])
        tipStackView.axis = .horizontal
        tipStackView.accessibilityLabel = "\(tipLabel) \(tipValue)"
        
        let totalpStackView = UIStackView(arrangedSubviews: [totalLabel, totalValue])
        totalpStackView.axis = .horizontal
        totalpStackView.accessibilityLabel = "\(totalLabel) \(totalValue)"
        
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
        
        contentView.addSubViews(stackView, segment)

        stackView.anchor(
            top: valueInput.bottomAnchor,
            left: valueInput.leftAnchor,
            bottom: nil,
            right: valueInput.rightAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 0),
            size: .init(width: 0, height: 280)
        )
        
        segment.anchor(
            top: stackView.bottomAnchor,
            left: stackView.leftAnchor,
            bottom: nil,
            right: stackView.rightAnchor,
            padding: .init(top: 5, left: 0, bottom: 0, right: 0),
            size: .init(width: 0, height: 35)
        )
        
        resetButton(contentView: contentView)
    }
    
    // MARK: - set the dynamic components
    private func resetButton(contentView: UIView) {
        let mesageLabel = UILabel()
        mesageLabel.numberOfLines = 0
        mesageLabel.text = LocalizedString.messageView
        mesageLabel.textColor = .systemGray
        mesageLabel.font = .preferredFont(forTextStyle: .title2)
        
        let horizontalStackView = UIStackView(arrangedSubviews: [UIView(), presentSheetButton])
        horizontalStackView.axis = .horizontal
        
        let stackView = UIStackView(arrangedSubviews: [clearValuesButton, horizontalStackView])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        
        contentView.addSubViews(stackView, mesageLabel)
        
        stackView.anchor(
            top: segment.bottomAnchor,
            left: segment.leftAnchor,
            bottom: nil,
            right: segment.rightAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 0),
            size: .init(width: 0, height: 85)
        )
        
        mesageLabel.anchor(
            top: stackView.bottomAnchor,
            left: stackView.leftAnchor,
            bottom: contentView.bottomAnchor,
            right: stackView.rightAnchor,
            padding: .init(top: 10, left: 10, bottom: 0, right: 10)
        )
        
    }
    
}


