//
//  Bill+CoreDataProperties.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/31/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//
//

import Foundation
import CoreData


extension Bill {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bill> {
        return NSFetchRequest<Bill>(entityName: "Bill")
    }

    @NSManaged public var input: String?
    @NSManaged public var tip: String?
    @NSManaged public var total: String?

}
