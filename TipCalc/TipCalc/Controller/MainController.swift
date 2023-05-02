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
        label.text = "$0.0"
        label.accessibilityHint = NSLocalizedString("Tip_value", comment: "Tip value")
        label.setSizeFont(sizeFont: 70)
        label.textAlignment = .right
        return label
    }()
    
    let totalValue: UILabel = {
        let label = UILabel()
        label.text = "$0.0"
        label.accessibilityHint = NSLocalizedString("Total_value_tip", comment: "Total value, tip plus initial value")
        label.setSizeFont(sizeFont: 70)
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Segmented Controller with value changed event for tip percentage
    let segment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["10%","15%", "20%", "25%"])
        let font = UIFont.preferredFont(forTextStyle: .callout)
        sc.setTitleTextAttributes([NSAttributedString.Key.font : font], for: .normal)
        sc.selectedSegmentIndex = 0
        sc.tintColor = .darkGray
        return sc
    }()
    
    let calculationsViewModel = CalculationsViewModel()
    let saveViewModel = SaveViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        valueInput.addTarget(self, action: #selector(changeValue), for: .editingChanged)
        segment.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        setNavbar()
        setMainView()
        tableViewHandlers()
        saveViewModel.fetchItems()
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
