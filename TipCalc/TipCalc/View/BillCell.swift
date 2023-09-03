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
        label.setBoldDynamicFont(font: .preferredFont(forTextStyle: .title1))
        label.text = "$0.0"
        return label
    }()
    
    private let billLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.0"
        label.setDynamicFont(font: .preferredFont(forTextStyle: .body))
        return label
    }()
    
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.0"
        label.setDynamicFont(font: .preferredFont(forTextStyle: .body))
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "00/00/2019"
        label.setDynamicFont(font: .preferredFont(forTextStyle: .caption2))
        label.textColor = .lightGray
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        return view
    }()
    
    func configure(bill: Bill?) {
        guard let total = bill?.total, let inputBill = bill?.input, let tip = bill?.tip, let date = bill?.date else { return }
        totalLabel.text = total
        billLabel.text = inputBill
        tipLabel.text = tip
        dateLabel.text = date
    }
    
    private func setLabels() {
        
        lineView.frame = .init(x: 0, y: 0, width: 5, height: frame.height)
        
        let bodyStackView = UIStackView(arrangedSubviews: [billLabel, tipLabel, dateLabel])
        bodyStackView.axis = .vertical
        bodyStackView.distribution = .fillProportionally
        bodyStackView.spacing = 3
        
        let stackView = UIStackView(arrangedSubviews:
            [totalLabel, bodyStackView]
        )
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 3
        
        addSubview(stackView)
        addSubview(lineView)
        
        lineView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, padding: .init(top: 5, left: 0, bottom: 5, right: 0), size: .init(width: 3, height: 0))
        lineView.backgroundColor = .random
        
        stackView.anchor(
            top: lineView.topAnchor,
            left: lineView.rightAnchor,
            bottom: lineView.bottomAnchor,
            right: rightAnchor,
            padding: .init(top: 10, left: 10, bottom: 10, right: 0)
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

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}
