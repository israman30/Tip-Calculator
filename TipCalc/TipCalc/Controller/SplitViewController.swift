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
        view.backgroundColor = .yellow
        setDetailView()
    }
    
    func setDetailView() {
        let stackView = UIStackView(arrangedSubviews: [totalLabel, billLabel, tipLabel, dateLabel])
        view.addSubview(stackView)
        stackView.backgroundColor = .red
        stackView.axis = .vertical
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 120))
    }
    
}
