//
//  BillCell.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit
import SwiftUI

/// `BillCellProtocol` is responsible for configuring the appearance and content of table view cells within a `UITableView`.
protocol BillCellProtocol {
    func configure(bill: Bill?)
}

/// `SetUIProtocol` is responsible for defining and applying the user interface elements within a view.
protocol SetUIProtocol {
    func setUI()
}

class BillCell: UITableViewCell, BillCellProtocol, SetUIProtocol {
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.setBoldDynamicFont(font: .preferredFont(forTextStyle: .extraLargeTitle2))
        label.text = Constant.zero
        label.textColor = .label
        return label
    }()
    
    private let billLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.zero
        label.setDynamicFont(font: .preferredFont(forTextStyle: .body))
        label.textColor = .label
        return label
    }()
    
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.zero
        label.setDynamicFont(font: .preferredFont(forTextStyle: .body))
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.defaultDate
        label.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        label.textColor = .darkGray
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let tagSplitLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.zero
        label.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        label.textAlignment = .center
        label.textColor = .label
        label.backgroundColor = .black.withAlphaComponent(0.07)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    func configure(bill: Bill?) {
        guard let total = bill?.total,
              let inputBill = bill?.input,
              let tip = bill?.tip,
              let date = bill?.date,
              let splitTotal = bill?.splitTotal,
              let splitQuantity = bill?.splitPeopleQuantity else { return }
        totalLabel.text = total
        billLabel.text = inputBill
        tipLabel.text = tip
        dateLabel.text = date
        /// Statement checks if bill is been splitted by number of people or none
        if splitQuantity == "1x" {
            tagSplitLabel.text = ""
        } else {
            tagSplitLabel.text = "\(splitTotal.currencyInputFormatting()) \(splitQuantity)"
            tagSplitLabel.accessibilityLabel = "\(splitTotal.currencyInputFormatting()) \(splitQuantity) people"
        }
    }
    
    func setUI() {
        
        lineView.frame = .init(x: 0, y: 0, width: 5, height: frame.height)
        
        let horizontalViewTips = UIStackView(arrangedSubviews: [tipLabel, UIView(), dateLabel])
        
        let bodyStackView = UIStackView(
            arrangedSubviews: [
                billLabel, horizontalViewTips
            ]
        )
        bodyStackView.axis = .vertical
        bodyStackView.distribution = .fillProportionally
        bodyStackView.spacing = 5
        
        let totalStackView = UIStackView(
            arrangedSubviews: [
                totalLabel, tagSplitLabel
            ]
        )
        totalStackView.axis = .horizontal
        totalStackView.distribution = .fillProportionally
        
        let stackView = UIStackView(
            arrangedSubviews: [
                totalStackView, bodyStackView
            ]
        )
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 3
        
        addSubViews(stackView, lineView)
        
        lineView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, padding: .init(top: 5, left: 0, bottom: 5, right: 0), size: .init(width: 3, height: 0))
        lineView.backgroundColor = .random
        
        stackView.anchor(
            top: lineView.topAnchor,
            left: lineView.rightAnchor,
            bottom: lineView.bottomAnchor,
            right: rightAnchor,
            padding: .init(top: 10, left: 5, bottom: 10, right: 5)
        )
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    UIViewPreview {
        BillCell()
    }
    .frame(width: 375, height: 150)
}
