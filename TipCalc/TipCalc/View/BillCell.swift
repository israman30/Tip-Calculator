//
//  BillCell.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

class BillCell: UITableViewCell {
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.text = "$0.0"
        return label
    }()
    
    private let billLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.0"
        label.font = .systemFont(ofSize: 13)
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.0"
        label.font = .systemFont(ofSize: 13)
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12/07/2019"
        label.font = .systemFont(ofSize: 11)
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .lightGray
        return label
    }()
    
    func configure(bill: Bill?) {
        guard let total = bill?.total, let inputBill = bill?.input, let tip = bill?.tip, let date = bill?.date else { return }
        totalLabel.text = total
        billLabel.text = inputBill
        tipLabel.text = tip
        dateLabel.text = date
    }
    
    private func setLabels() {
        let stackView = UIStackView(arrangedSubviews:
            [totalLabel, billLabel, tipLabel, dateLabel]
        )
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        addSubview(stackView)
        stackView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            padding: .init(top: 10, left: 0, bottom: 10, right: 0)
        )
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
