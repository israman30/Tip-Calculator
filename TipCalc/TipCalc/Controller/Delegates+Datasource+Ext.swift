//
//  Delegates+Datasource+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

extension MainController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - TableView delegate and datasource + cell registration
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
        cell.configure(bill: sortedBills[indexPath.row])
        return cell
    }
    
    // MARK: - Method delete from db with context then save what still in db, when user swipe editingStyle.delete cell using indexPath
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
    
    // MARK: - Find the way for display the tableView when tap in a arrow row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//        present(SplitViewController(), animated: true)
    }
}

extension UITableView {
    func tableViewEmpty(with title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = .systemGray2
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        titleLabel.numberOfLines = 2
        messageLabel.textColor = .gray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2
        messageLabel.font = .preferredFont(forTextStyle: .body)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: emptyView.bounds.size.width, height: 0))
        
        titleLabel.text = title
        messageLabel.text = message
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
