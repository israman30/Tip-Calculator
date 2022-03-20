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
        tv.rowHeight = 100
        tv.showsVerticalScrollIndicator = false
        tv.allowsSelection = false
        return tv
    }()
    
    // MARK: - TextField with editingChanged event, that allows to interact with the label tip and total
    let valueInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter value"
        tf.font = .preferredFont(forTextStyle: .title1)
        tf.adjustsFontForContentSizeCategory = true
        tf.accessibilityHint = "Input bill value"
        tf.textAlignment = .right
        tf.isUserInteractionEnabled = true
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    // MARK: - TextField bottom border
    let bottomView = UIView()
    
    let tipValue: UILabel = {
        let label = UILabel()
        label.text = "$0.0"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityHint = "Tip value"
        label.textAlignment = .right
        return label
    }()
    
    let totalValue: UILabel = {
        let label = UILabel()
        label.text = "$0.0"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityHint = "Total value, tip plus initial value"
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Segmented Controller with value changed event for tip percentage
    let segment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["15%", "20%", "25%"])
        let font = UIFont.preferredFont(forTextStyle: .callout)
        sc.setTitleTextAttributes([NSAttributedString.Key.font : font], for: .normal)
        sc.selectedSegmentIndex = 0
        sc.tintColor = .darkGray
        sc.accessibilityHint = "Segmented values"
        return sc
    }()
    
    let calculationsViewModel = CalculationsViewModel()
    let saveViewModel = SaveViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        valueInput.addTarget(self, action: #selector(changeValue), for: .editingChanged)
        segment.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        setNavbar()
        setMainView()
        tableViewHandlers()
        fetchItems()
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
