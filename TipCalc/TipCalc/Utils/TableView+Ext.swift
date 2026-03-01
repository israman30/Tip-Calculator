//
//  TableView+Ext.swift
//  TipCalc
//
//  Created by Israel Manzo on 3/4/25.
//  Copyright © 2025 Israel Manzo. All rights reserved.
//

import UIKit

extension UITableView {
    func tableViewEmpty(with title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let iconView = UIImageView(image: UIImage(systemName: "doc.text.magnifyingglass"))
        iconView.tintColor = .tertiaryLabel
        iconView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.numberOfLines = 2
        messageLabel.textColor = .tertiaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 3
        messageLabel.font = .preferredFont(forTextStyle: .body)
        
        let stackView = UIStackView(arrangedSubviews: [iconView, titleLabel, messageLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: emptyView.bounds.size.width - 48, height: 0))
        
        iconView.anchor(top: nil, left: nil, bottom: nil, right: nil, size: .init(width: 64, height: 64))
        
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
