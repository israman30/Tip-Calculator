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
    
    // MARK: - Navbar with prominent Save button (icon + label) for visibility and better UX
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
        
        let saveButton = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: Constant.pin_circle)
        config.imagePlacement = .leading
        config.imagePadding = 6
        config.baseForegroundColor = .white
        config.background.backgroundColor = .systemGreen
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14)
        config.title = NSLocalizedString("Save", comment: "Save button title")
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { _ in
            var attributes = AttributeContainer()
            attributes.font = .systemFont(ofSize: 15, weight: .semibold)
            return attributes
        }
        saveButton.configuration = config
        saveButton.accessibilityLabel = NSLocalizedString("Save bill", comment: "Save button label")
        saveButton.accessibilityHint = AccessibilityLabels.pintButtonHint
        saveButton.addTarget(self, action: #selector(handleSaveBill), for: .touchUpInside)
        
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButton
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

        setupCategoryPicker(contentView: contentView, inputCard: inputCard)
    }

    private func setupCategoryPicker(contentView: UIView, inputCard: UIView) {
        let categoryLabel = UILabel()
        categoryLabel.text = NSLocalizedString("Category", comment: "Bill category label")
        categoryLabel.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        categoryLabel.textColor = .secondaryLabel

        categoryScrollView.addSubview(categoryStackView)
        categoryStackView.anchor(
            top: categoryScrollView.topAnchor,
            left: categoryScrollView.leftAnchor,
            bottom: categoryScrollView.bottomAnchor,
            right: categoryScrollView.rightAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 12)
        )
        categoryStackView.heightAnchor.constraint(equalTo: categoryScrollView.heightAnchor).isActive = true

        let categoryCard = createCardView()
        let categoryHeaderStack = UIStackView(arrangedSubviews: [categoryLabel])
        categoryHeaderStack.axis = .horizontal
        let categoryStack = UIStackView(arrangedSubviews: [categoryHeaderStack, categoryScrollView])
        categoryStack.axis = .vertical
        categoryStack.spacing = 8
        categoryCard.addSubview(categoryStack)

        contentView.addSubview(categoryCard)
        categoryCard.anchor(
            top: inputCard.bottomAnchor,
            left: contentView.leftAnchor,
            bottom: nil,
            right: contentView.rightAnchor,
            padding: .init(top: 10, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 56)
        )
        categoryStack.anchor(
            top: categoryCard.topAnchor,
            left: categoryCard.leftAnchor,
            bottom: categoryCard.bottomAnchor,
            right: categoryCard.rightAnchor,
            padding: .init(top: 10, left: 10, bottom: 10, right: 10)
        )

        refreshCategoryChips()
        outputValues(contentView: contentView, inputCard: inputCard, categoryCard: categoryCard)
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
    private func outputValues(contentView: UIView, inputCard: UIView, categoryCard: UIView? = nil) {
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
        contentView.addSubViews(resultsCard, segment, tipSliderContainerView)
        
        let topAnchorView = categoryCard ?? inputCard
        resultsCard.anchor(
            top: topAnchorView.bottomAnchor,
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
        
        // Custom tip slider positioned under segmented control
        tipSliderPercentLabel.text = "\(Int(tipSlider.value))%"
        let sliderRowStack = UIStackView(arrangedSubviews: [tipSlider, tipSliderPercentLabel])
        sliderRowStack.axis = .horizontal
        sliderRowStack.spacing = 12
        sliderRowStack.alignment = .center
        tipSliderPercentLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        let customTipLabel = UILabel()
        customTipLabel.text = NSLocalizedString("Custom tip", comment: "Custom tip slider label")
        customTipLabel.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        customTipLabel.textColor = .secondaryLabel
        
        let sliderContainerStack = UIStackView(arrangedSubviews: [customTipLabel, sliderRowStack])
        sliderContainerStack.axis = .horizontal
        sliderContainerStack.alignment = .center
        sliderContainerStack.distribution = .fill
        tipSliderContainerView.addSubview(sliderContainerStack)
        
        tipSliderContainerView.translatesAutoresizingMaskIntoConstraints = false
        tipSliderContainerView.anchor(
            top: segment.bottomAnchor,
            left: contentView.leftAnchor,
            bottom: nil,
            right: contentView.rightAnchor,
            padding: .init(top: 10, left: 10, bottom: 0, right: 10)
        )
        
        sliderContainerStack.translatesAutoresizingMaskIntoConstraints = false
        sliderContainerStack.anchor(
            top: tipSliderContainerView.topAnchor,
            left: tipSliderContainerView.leftAnchor,
            bottom: tipSliderContainerView.bottomAnchor,
            right: tipSliderContainerView.rightAnchor,
            padding: .init(top: 8, left: 0, bottom: 8, right: 0)
        )
        
        tipSliderHeightConstraint = tipSliderContainerView.heightAnchor.constraint(equalToConstant: 0)
        tipSliderHeightConstraint?.isActive = true
        
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
            top: tipSliderContainerView.bottomAnchor,
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


