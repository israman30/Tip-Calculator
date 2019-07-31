//
//  MainView.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

extension MainController {
    
    // MARK: - Keyboard dismiss
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setNavbar() {
        navigationItem.title = "Calculate tip"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(handleSaveBill)
        )
    }
    
    func setMainView(){
        
        view.backgroundColor = .white
        
        bottomView.backgroundColor = .lightGray
        
        view.addSubview(valueInput)
        view.addSubview(bottomView)
        
        valueInput.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: .init(top: 10, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 50))
        
        bottomView.anchor(top: valueInput.bottomAnchor, left: valueInput.leftAnchor, bottom: nil, right: valueInput.rightAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 2))
        outputValues()
    }
    
    func outputValues() {
        
        let tipLabel = UILabel()
        tipLabel.text = "Tip"
        tipLabel.textAlignment = .right
        tipLabel.textColor = .lightGray
        let totalLabel = UILabel()
        totalLabel.text = "Total"
        totalLabel.textAlignment = .right
        totalLabel.textColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [tipLabel, tipValue, totalLabel,totalValue])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 5
        
        view.addSubview(stackView)
        stackView.anchor(top: bottomView.bottomAnchor, left: bottomView.leftAnchor, bottom: nil, right: bottomView.rightAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 180))
        
        view.addSubview(segment)
        segment.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: stackView.rightAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        resetButton()
    }
    
    func resetButton() {
        
        let btn = UIButton(type: .system)
        btn.setTitle("RESET", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(handleResetFields), for: .touchUpInside)
        view.addSubview(btn)
        btn.anchor(top: segment.bottomAnchor, left: segment.leftAnchor, bottom: nil, right: segment.rightAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        
        view.addSubview(tableView)
        tableView.anchor(top: btn.bottomAnchor, left: btn.leftAnchor, bottom: view.bottomAnchor, right: btn.rightAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    
}


