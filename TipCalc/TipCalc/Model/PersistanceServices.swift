//
//  PersistanceServices.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/30/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit
import CoreData

enum PersistenceError: Error {
    case saveError(NSError, userInfo: [String:Any])
    case loadPersistentStoreError(NSError, userInfo: [String:Any])
    
    var localizedDescription: String {
        switch self {
        case .saveError(let error, let userInfo):
            return "Failed to save context: \(error.localizedDescription) and info: \(userInfo)"
        case .loadPersistentStoreError(let error, let userInfo):
            return "Failed to load persistent store: \(error.localizedDescription) and info: \(userInfo))"
        }
    }
}

class PersistanceServices {
    
    static var context: NSManagedObjectContext {
        return persitantContrainer.viewContext
    }
    
    static var persitantContrainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TipCalc")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as? NSError {
                print(PersistenceError.saveError(error, userInfo: error.userInfo))
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
            } catch let error as NSError  {
                print(PersistenceError.saveError(error, userInfo: error.userInfo))
            }
        }
    }
}

//struct Bill {
//    let input: String
//    let tip: String
//    let total: String
//}


