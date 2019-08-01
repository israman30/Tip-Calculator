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
    
    static var context: NSManagedObjectContext {
        return persitantContrainer.viewContext
    }
    
    static var persitantContrainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TipCalc")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unceratain Error \(error)")
            }
            print(storeDescription)
        })
        return container
    }()
    
    static func saveContext() {
        let context = persitantContrainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                fatalError("Error loading a container \(error)")
            }
        }
    }
}

//struct Bill {
//    let input: String
//    let tip: String
//    let total: String
//}


