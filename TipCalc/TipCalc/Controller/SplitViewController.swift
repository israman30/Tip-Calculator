//
//  SplitViewController.swift
//  TipCalc
//
//  Created by Israel Manzo on 5/3/23.
//  Copyright © 2023 Israel Manzo. All rights reserved.
//

import UIKit

class SplitViewController: UIViewController {
    
    private let totalLabel: UITextField = {
        let label = UITextField()
        label.setBoldDynamicFont(font: .preferredFont(forTextStyle: .title1))
        label.text = Constant.zero
        return label
    }()
    
    private let billLabel: UITextField = {
        let label = UITextField()
        label.text = Constant.zero
        label.setDynamicFont(font: .preferredFont(forTextStyle: .body))
        return label
    }()
    
    private let tipLabel: UITextField = {
        let label = UITextField()
        label.text = Constant.zero
        label.setDynamicFont(font: .preferredFont(forTextStyle: .body))
        return label
    }()
    
    private let dateLabel: UITextField = {
        let label = UITextField()
        label.text = Constant.defaultDate
        label.setDynamicFont(font: .preferredFont(forTextStyle: .caption2))
        label.textColor = .lightGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setDetailView()
    }
    
    func setDetailView() {
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        
        let stackView = UIStackView(
            arrangedSubviews: [
                totalLabel, billLabel, tipLabel, dateLabel
            ]
        )
        view.addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        containerView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: nil,
            right: view.rightAnchor,
            padding: .init(top: 20, left: 20, bottom: 0, right: 20),
            size: .init(width: 0, height: 140)
        )
        
        stackView.anchor(
            top: containerView.topAnchor,
            left: containerView.leftAnchor,
            bottom: containerView.bottomAnchor,
            right: containerView.rightAnchor,
            padding: .init(top: 16, left: 20, bottom: 16, right: 20)
        )
    }
    
}
