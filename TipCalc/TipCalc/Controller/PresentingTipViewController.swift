//
//  PresntTipViewController.swift
//  TipCalc
//
//  Created by Israel Manzo on 3/1/25.
//  Copyright © 2025 Israel Manzo. All rights reserved.
//
import UIKit

class PresentingTipViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = UITableView.automaticDimension
        tv.showsVerticalScrollIndicator = false
        tv.allowsSelection = false
        return tv
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        return button
    }()
    
    let saveViewModel = SaveViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        view.backgroundColor = .systemBackground
        
        view.addSubViews(topView, tableView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, size: .init(width: 0, height: 60))
        tableView.anchor(top: topView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        let navBarStackView = UIStackView(arrangedSubviews: [UIView(), UIView(), dismissButton])
        navBarStackView.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(navBarStackView)
        
        navBarStackView.anchor(top: topView.topAnchor, left: topView.leftAnchor, bottom: topView.bottomAnchor, right: topView.rightAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10))
        
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        tableViewHandlers()
        saveViewModel.fetchItems()
        
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true)
    }
    
    func tableViewHandlers() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BillCell.self, forCellReuseIdentifier: CellId.cell.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveViewModel.bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId.cell.rawValue) as! BillCell
        cell.configure(bill: saveViewModel.bills[indexPath.row])
        return cell
    }
}
