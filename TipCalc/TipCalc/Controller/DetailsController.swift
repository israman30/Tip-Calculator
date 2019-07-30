//
//  DetailsController.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit


class DetailController: UITableViewController {
    
    var bill = [Bill]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(BillCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bill.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BillCell
        cell.bills = bill[indexPath.row]
        return cell
    }
}

class BillCell: UITableViewCell {
    
    var bills: Bill? {
        didSet {
            guard let total = bills?.total,
                   let bill = bills?.input,
                   let tip = bills?.tip else { return }
            totalLabel.text = total
            billLabel.text = bill
            tipLabel.text = tip
        }
    }
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "$0.0"
        return label
    }()
    
    let billLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.0"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.0"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12/07/2019"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .lightGray
        return label
    }()
    
    func setLabels(){
        let stackView = UIStackView(arrangedSubviews:
            [totalLabel, billLabel, tipLabel, dateLabel]
        )
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
