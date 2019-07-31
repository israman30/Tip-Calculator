//
//  PersistanceServices.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit
import CoreData

class PersistanceServices {
    
    static var persitantContrainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TipCalc")
        return container
    }()
}

//struct Bill {
//    let input: String
//    let tip: String
//    let total: String
//}


