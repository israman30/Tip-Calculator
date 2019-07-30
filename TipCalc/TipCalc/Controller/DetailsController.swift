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
    
    let billLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.0"
        return label
    }()
    
    let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.0"
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.0"
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12/07/2019"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(totalLabel)
        addSubview(billLabel)
        addSubview(tipLabel)
        addSubview(dateLabel)
        
        totalLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        
        billLabel.anchor(top: totalLabel.bottomAnchor, left: totalLabel.leftAnchor, bottom: nil, right: totalLabel.rightAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        tipLabel.anchor(top: billLabel.bottomAnchor, left: billLabel.leftAnchor, bottom: nil, right: billLabel.rightAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        dateLabel.anchor(top: tipLabel.bottomAnchor, left: tipLabel.leftAnchor, bottom: nil, right: tipLabel.rightAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
