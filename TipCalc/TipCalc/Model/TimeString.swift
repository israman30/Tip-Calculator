//
//  TimeString.swift
//  TipCalc
//
//  Created by Israel Manzo on 8/17/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit

class TimeString {
    // MARK: - setDate function returns a Date of type String that is assigned to the date object created by the context
    static func setDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: Date())
    }
}
