//
//  AccessibilityUtils.swift
//  TipCalc
//
//  Created by Israel Manzo on 1/29/23.
//  Copyright © 2023 Israel Manzo. All rights reserved.
//

import UIKit

extension UILabel {
    
    func makeFontAccessible(textStyle: UIFont.TextStyle, label: String? = nil, hint: String? = nil, trait: UIAccessibilityTraits? = nil) {
        guard let label = label, let hint = hint, let trait = trait else { return }
        adjustsFontForContentSizeCategory = true
        font = .preferredFont(forTextStyle: textStyle)
        accessibilityLabel = label
        accessibilityHint = hint
        accessibilityTraits.insert(trait)
    }
}

extension UITextField {
    func makeFontAccessible(textStyle: UIFont.TextStyle, label: String? = nil, hint: String? = nil, trait: UIAccessibilityTraits? = nil) {
        guard let label = label, let hint = hint, let trait = trait else { return }
        adjustsFontForContentSizeCategory = true
        font = .preferredFont(forTextStyle: textStyle)
        accessibilityLabel = label
        accessibilityHint = hint
        accessibilityTraits.insert(trait)
    }
}


extension UILabel {
    func makeFontDynamic() {
        adjustsFontForContentSizeCategory = true
        
        font = UIFontMetrics.default.scaledFont(for: font)
    }
    func sizedDynamicFont() {
        let pointSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
        font = font.withSize(pointSize)
        adjustsFontForContentSizeCategory = true
    }
}
extension UIView {
    func setDynamicFont(font: UIFont) {
        if  let adjustable = self as? UIContentSizeCategoryAdjusting {
            adjustable.adjustsFontForContentSizeCategory = true
        }
        
        if let label = self as? UILabel {
            label.font = font
        } else if let button = self as? UIButton {
            button.titleLabel?.font = font
        } else if let textField = self as? UITextField {
            textField.font = font
        } else if let textView = self as? UITextView {
            textView.font = font
        } else {
            
        }
    }
}
