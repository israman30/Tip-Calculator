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
