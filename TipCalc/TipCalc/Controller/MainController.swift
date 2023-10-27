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
        tf.placeholder = NSLocalizedString("Enter_value", comment: "Enter value") 
        tf.accessibilityHint = NSLocalizedString("Input_bill_value", comment: "Input the bill value") 
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
        label.text = Constants.zero
        label.accessibilityHint = NSLocalizedString("Tip_value", comment: "Tip value")
        label.setSizeFont(sizeFont: 70)
        label.textAlignment = .right
        return label
    }()
    
    let totalValue: UILabel = {
        let label = UILabel()
        label.text = Constants.zero
        label.accessibilityHint = NSLocalizedString("Total_value_tip", comment: "Total value, tip plus initial value")
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
        label.text = Constants.zero
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
        let sc = UISegmentedControl(items: ["10%","15%", "20%", "25%"])
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
        btn.setTitle(NSLocalizedString("Clear_values", comment: "CLEAR VALUES"), for: .normal)
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

// MARK: - SWIFT UI PREVIEW CLASS HELPER WITH CONTAINER VIEW
@available(iOS 13.0.0, *)
class PreviewTipCal: PreviewProvider {
    
    @available(iOS 13.0.0, *)
    static var previews: some View {
        ContainerView()
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        // MARK: - MAKE UI VIEW CONTROLLER OVERRITED METHOD TO RETURN HOME VIEW CONTROLLER
        func makeUIViewController(context: UIViewControllerRepresentableContext<PreviewTipCal.ContainerView>) -> UIViewController {
            return UINavigationController(rootViewController: MainController())
        }
        
        func updateUIViewController(_ uiViewController: PreviewTipCal.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PreviewTipCal.ContainerView>) {
            // Nothing
        }
    }
}
