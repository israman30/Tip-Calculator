//
//  MainController.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/29/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit
import CoreData

/**
 - TIP CALCULATOR USES CORE DATA  API AS DATABASE
 - USING SWIFTUI API TO PREVIEW APP VIEW
 */
//["10%", "15%", "20%", "25%"]
enum Percentages: Int, CaseIterable {
    case ten_percent = 0
    case fifteen_percent = 1
    case twienty_percent = 2
    case twientyfive_percent = 3
    
    var description: String {
        switch self {
        case .ten_percent:
            return "10%"
        case .fifteen_percent:
            return "15%"
        case .twienty_percent:
            return "20%"
        case .twientyfive_percent:
            return "25%"
        }
    }
}

class MainController: UIViewController {
    
    // MARK: - TableView display list of saved bills
    let tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = UITableView.automaticDimension
        tv.showsVerticalScrollIndicator = false
        tv.allowsSelection = false
        return tv
    }()
    
    // MARK: - TextField with editingChanged event, that allows to interact with the label tip and total
    let valueInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = LocalizedString.textField_placeholder
        tf.accessibilityHint = LocalizedString.textField_hint
        tf.setDynamicFont(font: .preferredFont(forTextStyle: .title1))
        tf.textAlignment = .right
        tf.isUserInteractionEnabled = true
        tf.keyboardType = .decimalPad
        tf.textColor = .label
        return tf
    }()
    
    // MARK: - TextField bottom border
    let bottomView = UIView()
    
    let tipValue: UILabel = {
        let label = UILabel()
        label.text = Constant.zero
        label.accessibilityHint = LocalizedString.tip_value_hint
        label.setSizeFont(sizeFont: 70)
        label.textAlignment = .right
        return label
    }()
    
    let totalValue: UILabel = {
        let label = UILabel()
        label.text = Constant.zero
        label.accessibilityHint = LocalizedString.total_value_hint
        label.setSizeFont(sizeFont: 70)
        label.textAlignment = .right
        return label
    }()
    
    let splitPeopleQuantity: UILabel = {
        let label = UILabel()
        label.setSizeFont(sizeFont: 25)
        return label
    }()
    
    let splitTotal: UILabel = {
        let label = UILabel()
        label.text = Constant.zero
        label.setSizeFont(sizeFont: 25)
        return label
    }()
    
    let splitStepper: UIStepper = {
        let st = UIStepper()
        st.minimumValue = 1
        st.maximumValue = 10
        st.autorepeat = true
        st.value = 1
        return st
    }()
    
    // MARK: - Segmented Controller with value changed event for tip percentage
    let segment: UISegmentedControl = {
        let sc = UISegmentedControl(items: Percentages.allCases.map { $0.description.capitalized })
        let font = UIFont.preferredFont(forTextStyle: .title2)
        sc.setTitleTextAttributes([
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor: UIColor.darkText
            ], for: .selected)
        sc.selectedSegmentIndex = 0
        sc.tintColor = .darkGray
        return sc
    }()
    
    let clearValuesButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(LocalizedString.clear_value_button_title, for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.titleLabel?.setDynamicFont(font: .preferredFont(forTextStyle: .body))
        btn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return btn
    }()
    
    let calculationsViewModel = CalculationsViewModel()
    let saveViewModel = SaveViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        valueInput.addTarget(self, action: #selector(changeValue), for: .editingChanged)
        segment.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        splitStepper.addTarget(self, action: #selector(changeStepperQuantity), for: .valueChanged)
        clearValuesButton.addTarget(self, action: #selector(handleResetFields), for: .touchUpInside)
        
        splitPeopleQuantity.text = "\(Int(splitStepper.value))x"
        setNavbar()
        setMainView()
        tableViewHandlers()
        saveViewModel.fetchItems()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


// MARK: - PREVIEW SECTION BLOCK USING SWIFT UI API PREVIEW PROVIDER + SWIFT VERSION SUPPORT
import SwiftUI

#Preview {
    UIViewControllerPreview {
        MainController()
    }
}
