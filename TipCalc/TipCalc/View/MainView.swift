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
        
        // Input card container
        let inputCard = createCardView()
        inputCard.addSubview(valueInput)
        
        // Add all UI elements to content view
        contentView.addSubViews(inputCard)
        
        // Setup scroll view constraints
        scrollView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        
        contentView.anchor(
            top: scrollView.topAnchor,
            left: scrollView.leftAnchor,
            bottom: scrollView.bottomAnchor,
            right: scrollView.rightAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        inputCard.anchor(
            top: contentView.topAnchor,
            left: contentView.leftAnchor,
            bottom: nil,
            right: contentView.rightAnchor,
            padding: .init(top: 10, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 70)
        )
        
        valueInput.anchor(
            top: inputCard.topAnchor,
            left: inputCard.leftAnchor,
            bottom: inputCard.bottomAnchor,
            right: inputCard.rightAnchor,
            padding: .init(top: 10, left: 10, bottom: 12, right: 10)
        )
        
        valueInput.addSubview(toastMessage.view)
        toastMessage.view.translatesAutoresizingMaskIntoConstraints = true
        toastMessage.view.anchor(
            top: valueInput.topAnchor,
            left: valueInput.leftAnchor,
            bottom: valueInput.bottomAnchor,
            right: valueInput.rightAnchor,
            padding: .init(top: 0, left: 0, bottom: 15, right: 0)
        )
        
        outputValues(contentView: contentView, inputCard: inputCard)
    }
    
    private func createCardView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.06
        return view
    }
    
    // MARK: - Set the output components
    private func outputValues(contentView: UIView, inputCard: UIView) {
        let tipLabel = UILabel()
        tipLabel.text = Constant.tip
        tipLabel.textAlignment = .left
        tipLabel.textColor = .secondaryLabel
        tipLabel.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        tipLabel.isAccessibilityElement = false
        
        let totalLabel = UILabel()
        totalLabel.text = Constant.total
        totalLabel.textAlignment = .left
        totalLabel.textColor = .secondaryLabel
        totalLabel.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        totalLabel.isAccessibilityElement = false
        
        let splitLabel = UILabel()
        splitLabel.text = Constant.split_bill
        splitLabel.textAlignment = .left
        splitLabel.textColor = .secondaryLabel
        splitLabel.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        splitLabel.isAccessibilityElement = false
        
        let tipStackView = UIStackView(arrangedSubviews: [tipLabel, UIView(), tipValue])
        tipStackView.axis = .horizontal
        tipStackView.alignment = .center
        tipStackView.accessibilityLabel = "\(tipLabel.text ?? "") \(tipValue.text ?? "")"
        
        let totalpStackView = UIStackView(arrangedSubviews: [totalLabel, UIView(), totalValue])
        totalpStackView.axis = .horizontal
        totalpStackView.alignment = .center
        totalpStackView.accessibilityLabel = "\(totalLabel.text ?? "") \(totalValue.text ?? "")"
        
        let splitValuesStackView = UIStackView(arrangedSubviews: [splitTotal, splitPeopleQuantity])
        splitValuesStackView.axis = .horizontal
        splitValuesStackView.spacing = 12
        
        let splitBillStackView = UIStackView(arrangedSubviews: [splitLabel, UIView(), splitValuesStackView])
        splitBillStackView.axis = .horizontal
        splitBillStackView.alignment = .center
        
        let resultsCard = createCardView()
        let resultsStackView = UIStackView(arrangedSubviews:
            [tipStackView, totalpStackView, splitBillStackView, splitStepper]
        )
        resultsStackView.distribution = .fillProportionally
        resultsStackView.axis = .vertical
        resultsStackView.spacing = 10
        
        resultsCard.addSubview(resultsStackView)
        contentView.addSubViews(resultsCard, segment)
        
        resultsCard.anchor(
            top: inputCard.bottomAnchor,
            left: contentView.leftAnchor,
            bottom: nil,
            right: contentView.rightAnchor,
            padding: .init(top: 10, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 260)
        )
        
        resultsStackView.anchor(
            top: resultsCard.topAnchor,
            left: resultsCard.leftAnchor,
            bottom: resultsCard.bottomAnchor,
            right: resultsCard.rightAnchor,
            padding: .init(top: 10, left: 10, bottom: 20, right: 10)
        )

        segment.anchor(
            top: resultsCard.bottomAnchor,
            left: contentView.leftAnchor,
            bottom: nil,
            right: contentView.rightAnchor,
            padding: .init(top: 10, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 40)
        )
        
        resetButton(contentView: contentView)
    }
    
    // MARK: - set the dynamic components
    private func resetButton(contentView: UIView) {
        let mesageLabel = UILabel()
        mesageLabel.numberOfLines = 0
        mesageLabel.text = LocalizedString.messageView
        mesageLabel.textColor = .secondaryLabel
        mesageLabel.font = .preferredFont(forTextStyle: .body)
        mesageLabel.textAlignment = .center
        
        let horizontalStackView = UIStackView(arrangedSubviews: [UIView(), presentSheetButton])
        horizontalStackView.axis = .horizontal
        
        let stackView = UIStackView(arrangedSubviews: [clearValuesButton, horizontalStackView])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 12
        
        contentView.addSubViews(stackView, mesageLabel)
        
        stackView.anchor(
            top: segment.bottomAnchor,
            left: contentView.leftAnchor,
            bottom: nil,
            right: contentView.rightAnchor,
            padding: .init(top: 20, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 90)
        )
        
        mesageLabel.anchor(
            top: stackView.bottomAnchor,
            left: contentView.leftAnchor,
            bottom: contentView.bottomAnchor,
            right: contentView.rightAnchor,
            padding: .init(top: 24, left: 24, bottom: 32, right: 24)
        )
    }
    
}


