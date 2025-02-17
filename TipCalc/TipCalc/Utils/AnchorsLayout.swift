//
//  AnchorsLayout.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/29/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

// --- Extensions help to create a ramdon lineView for each cell ---
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

/// Extension component for managing `Light` and `Dark` themes.
extension UIColor {
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return light }
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
    
    static let customTableViewColor: UIColor = .dynamicColor(light: .black, dark: .white)
    static let customControlLabelColor: UIColor = .dynamicColor(light: .black, dark: .white)
    static let customLabelColor: UIColor = .dynamicColor(light: .white, dark: .black)
    static let customPlaceholderLabelColor: UIColor = .dynamicColor(light: .systemGray4, dark: .black)
}

/// Extension helper to add multiple views in a single method.
extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

/**
 UIView extension with an anchor method for setting `constraints` on the view.
 */
struct AnchoredConstraints {
    var top, left, bottom, right, width, height: NSLayoutConstraint?
}

extension UIView {
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(
                equalTo: top,
                constant: padding.top
            )
        }
        
        if let left = left {
            anchoredConstraints.left = leftAnchor.constraint(
                equalTo: left,
                constant: padding.left
            )
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(
                equalTo: bottom,
                constant: -padding.bottom
            )
        }
        
        if let right = right {
            anchoredConstraints.right = rightAnchor.constraint(
                equalTo: right,
                constant: -padding.right
            )
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(
                equalToConstant: size.width
            )
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(
                equalToConstant: size.height
            )
        }
        
        [anchoredConstraints.top,
         anchoredConstraints.left,
         anchoredConstraints.bottom,
         anchoredConstraints.right,
         anchoredConstraints.width,
         anchoredConstraints.height].forEach { $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(
                equalTo: superviewTopAnchor,
                constant: padding.top
            ).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(
                equalTo: superviewBottomAnchor,
                constant: -padding.bottom
            ).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(
                equalTo: superviewLeadingAnchor,
                constant: padding.left
            ).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(
                equalTo: superviewTrailingAnchor,
                constant: -padding.right
            ).isActive = true
        }
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
}
