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
        navigationItem.accessibilityTraits.insert(.header)
        
        let pin = UIImageView(image: UIImage(systemName: Constant.pin_circle))
        let pinView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
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
        
        bottomView.backgroundColor = .systemGray5
        
        // Add scroll view to main view
        view.addSubview(scrollView)
        
        // Add content view to scroll view
        scrollView.addSubview(contentView)
        
        // Add all UI elements to content view instead of main view
        contentView.addSubViews(valueInput, bottomView)
        
        // Setup scroll view constraints
        scrollView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
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
        toastMessage.view.anchor(top: valueInput.topAnchor, left: valueInput.leftAnchor, bottom: valueInput.bottomAnchor, right: valueInput.rightAnchor, padding: .init(top: 0, left: 0, bottom: 45, right: 0))
        
        bottomView.anchor(
            top: valueInput.bottomAnchor,
            left: valueInput.leftAnchor,
            bottom: nil,
            right: valueInput.rightAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0),
            size: .init(width: 0, height: 1)
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
            top: bottomView.bottomAnchor,
            left: bottomView.leftAnchor,
            bottom: nil,
            right: bottomView.rightAnchor,
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
        let horizontalStackView = UIStackView(arrangedSubviews: [UIView(), presentSheetButton])
        horizontalStackView.axis = .horizontal
        
        let stackView = UIStackView(arrangedSubviews: [clearValuesButton, horizontalStackView])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        
        contentView.addSubViews(stackView, tableView)
        
        stackView.anchor(
            top: segment.bottomAnchor,
            left: segment.leftAnchor,
            bottom: nil,
            right: segment.rightAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 0),
            size: .init(width: 0, height: 75)
        )
        
        // Update table view to not scroll independently and make height dynamic
        tableView.isScrollEnabled = false
        tableView.anchor(
            top: stackView.bottomAnchor,
            left: stackView.leftAnchor,
            bottom: contentView.bottomAnchor,
            right: stackView.rightAnchor,
            padding: .init(top: 0, left: 0, bottom: 10, right: 0)
        )
    }
    
    // MARK: - Update table view height based on content
    func updateTableViewHeight() {
        let numberOfRows = saveViewModel?.bills.count ?? 0
        let cellHeight: CGFloat = 100 // Approximate height of BillCell including padding
        let totalHeight = CGFloat(numberOfRows) * cellHeight
        let minHeight: CGFloat = 200
        
        // Remove existing height constraints
        tableView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                tableView.removeConstraint(constraint)
            }
        }
        
        // Add new height constraint
        let newHeight = max(totalHeight, minHeight)
        tableView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
        
        // Force layout update
        view.layoutIfNeeded()
    }
}


