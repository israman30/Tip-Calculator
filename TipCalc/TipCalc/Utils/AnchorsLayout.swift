//
//  AnchorsLayout.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/29/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

extension UIView {
    func addConstrains(_ subview: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: multiplier, constant: constant)
        let verticalConstraint = NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: multiplier, constant: constant)
        let widthConstraint = NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constant)
        let heightConstraint = NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constant)
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
}

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
//extension UIColor {
//    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
//        guard #available(iOS 13.0, *) else { return light }
//        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
//    }
//    
//    static let customTableViewColor: UIColor = .dynamicColor(light: .black, dark: .white)
//    static let customControlLabelColor: UIColor = .dynamicColor(light: .black, dark: .white)
//    static let customLabelColor: UIColor = .dynamicColor(light: .white, dark: .black)
//    static let customPlaceholderLabelColor: UIColor = .dynamicColor(light: .systemGray4, dark: .black)
//}

/// Extension helper to add multiple views in a single method.
extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

/**
 MARK: - Auto Layout Helper
 UIView extension with an anchor method for setting constraints on the view.
 Provides simplified Auto Layout API for common constraint scenarios.
 */
struct AnchoredConstraints {
    var top, left, bottom, right, width, height: NSLayoutConstraint?
}

extension UIView {
    
    // MARK: - Primary Anchor Method
    // Simplified Auto Layout constraint setup with padding and size support
    // Returns AnchoredConstraints for further constraint modifications
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
    
    // MARK: - Fill Superview
    // Constrains view to fill its superview with optional padding
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
    
    // MARK: - Center in Superview
    // Centers view within its superview with optional size constraints
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
