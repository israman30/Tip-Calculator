//
//  Bill+CoreDataClass.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/31/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//
//

import Foundation
import CoreData


public class Bill: NSManagedObject {

}

// MARK: - Equatable conformance for Bill
extension Bill {
    public static func == (lhs: Bill, rhs: Bill) -> Bool {
        return lhs.objectID == rhs.objectID
    }
}
