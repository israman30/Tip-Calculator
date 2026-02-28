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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Saved Bills", comment: "Saved bills title")
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.swipeToDeleteHint
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .tertiaryLabel
        return label
    }()

    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()

    private let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator.withAlphaComponent(0.5)
        return view
    }()

    var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 120
        tv.showsVerticalScrollIndicator = false
        tv.separatorColor = .clear
        tv.allowsSelection = false
        tv.backgroundColor = .systemGroupedBackground
        tv.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 24, right: 0)
        return tv
    }()

    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: Constant.xmark_circle, withConfiguration: config), for: .normal)
        button.tintColor = .secondaryLabel
        button.accessibilityLabel = NSLocalizedString("Close", comment: "Close button")
        button.accessibilityHint = NSLocalizedString("Dismiss saved bills list", comment: "Dismiss hint")
        return button
    }()
    
    var saveViewModel: SaveViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveViewModel = SaveViewModel()
        setUI()
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        tableViewHandlers()
        saveViewModel?.fetchItems()
        tableView.reloadData()
    }
    
    deinit {
        saveViewModel = nil
    }
    
    func setUI() {
        view.backgroundColor = .systemGroupedBackground

        view.addSubViews(topView, tableView)

        topView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        topView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: nil,
            right: view.rightAnchor,
            size: .init(width: 0, height: 76)
        )
        tableView.anchor(
            top: topView.bottomAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: 16)
        )

        topView.addSubViews(titleLabel, subtitleLabel, dismissButton, topSeparatorView)

        titleLabel.anchor(
            top: topView.topAnchor,
            left: topView.leftAnchor,
            bottom: nil,
            right: nil,
            padding: .init(top: 16, left: 20, bottom: 0, right: 0)
        )
        subtitleLabel.anchor(
            top: titleLabel.bottomAnchor,
            left: topView.leftAnchor,
            bottom: nil,
            right: nil,
            padding: .init(top: 4, left: 20, bottom: 0, right: 0)
        )
        dismissButton.anchor(
            top: nil,
            left: nil,
            bottom: nil,
            right: topView.rightAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 16),
            size: .init(width: 44, height: 44)
        )
        dismissButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        topSeparatorView.anchor(
            top: nil,
            left: topView.leftAnchor,
            bottom: topView.bottomAnchor,
            right: topView.rightAnchor,
            padding: .zero,
            size: .init(width: 0, height: 1.0 / UIScreen.main.scale)
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
        if saveViewModel?.sortedBills.count == 0 {
            tableView.tableViewEmpty(with: LocalizedString.emptyTableViewTitle, message: LocalizedString.emptyTableViewMessage)
        } else {
            tableView.restore()
        }
        return saveViewModel?.sortedBills.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId.cell.rawValue) as! BillCell
        guard let sortedBills = saveViewModel?.sortedBills else { return cell }
        cell.configure(bill: sortedBills[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let sortedBills = saveViewModel?.sortedBills,
                  indexPath.row < sortedBills.count else { return }
            
            let billToDelete = sortedBills[indexPath.row]
            
            // Remove from the original bills array
            if let index = saveViewModel?.sortedBills.firstIndex(of: billToDelete) {
                saveViewModel?.bills.remove(at: index)
            }
            
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            PersistanceServices.context.delete(billToDelete)
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
