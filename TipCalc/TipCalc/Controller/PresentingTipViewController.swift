//
//  PresntTipViewController.swift
//  TipCalc
//
//  Created by Israel Manzo on 3/1/25.
//  Copyright © 2025 Israel Manzo. All rights reserved.
//
import UIKit
import SwiftUI

class PresentingTipViewController: UIViewController, TableViewProtocol, SetUIProtocol, SaveViewModelProtocol {
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = UITableView.automaticDimension
        tv.showsVerticalScrollIndicator = false
        tv.allowsSelection = false
        return tv
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constant.xmark_circle), for: .normal)
        return button
    }()
    
    var saveViewModel: SaveViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveViewModel = SaveViewModel()
        tableView.reloadData()
        setUI()
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        tableViewHandlers()
        saveViewModel?.fetchItems()
    }
    
    deinit {
        saveViewModel = nil
    }
    
    func setUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubViews(topView, tableView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        topView.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: nil,
            right: view.rightAnchor,
            size: .init(width: 0, height: 60)
        )
        tableView.anchor(
            top: topView.bottomAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            padding: .init(top: 0, left: 5, bottom: 0, right: 5)
        )
        
        let navBarStackView = UIStackView(
            arrangedSubviews: [UIView(), UIView(), dismissButton]
        )
        navBarStackView.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(navBarStackView)
        
        navBarStackView.anchor(
            top: topView.topAnchor,
            left: topView.leftAnchor,
            bottom: topView.bottomAnchor,
            right: topView.rightAnchor,
            padding: .init(top: 0, left: 10, bottom: 0, right: 10)
        )
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true)
    }
    
}

extension PresentingTipViewController: UITableViewDelegate, UITableViewDataSource {
    func tableViewHandlers() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BillCell.self, forCellReuseIdentifier: CellId.cell.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if saveViewModel?.bills.count == 0 {
            tableView.tableViewEmpty(with: LocalizedString.emptyTableViewTitle, message: LocalizedString.emptyTableViewMessage)
        } else {
            tableView.restore()
        }
        return saveViewModel?.bills.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId.cell.rawValue) as! BillCell
        guard let sortedBills = saveViewModel?.bills.sorted(by: { $0.date ?? "" > $1.date ?? "" }) else { return cell }
        cell.configure(bill:sortedBills[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let index = saveViewModel?.bills.remove(at: indexPath.row) else { return }
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            PersistanceServices.context.delete(index)
            PersistanceServices.saveContext()
        } else {
            tableView.reloadData()
        }
    }
}

#Preview {
    UIViewControllerPreview {
        PresentingTipViewController()
    }
}
