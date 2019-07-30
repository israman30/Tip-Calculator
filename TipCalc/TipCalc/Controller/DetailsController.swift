//
//  DetailsController.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit


class DetailController: UITableViewController {
    
    var bill = [String]()
    
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
        cell.totalLabel.text = bill[indexPath.row]
        return cell
    }
}

class BillCell: UITableViewCell {
    
    let billLabel: UILabel = {
        let label = UILabel()
        label.text = "Bill"
        return label
    }()
    
    let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "Tip"
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total"
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(totalLabel)
        addSubview(billLabel)
        
        totalLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        
        billLabel.anchor(top: totalLabel.bottomAnchor, left: totalLabel.leftAnchor, bottom: nil, right: totalLabel.rightAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
