//
//  DataController.swift
//  TravelDiary
//
//  Created by Heeral on 5/29/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataController {
    let persistentContainer:NSPersistentContainer
    
    let Google_Client_ID:String = "633354884666-kerjfpnoscd5a4tlevm4ghnpts5rl2pt.apps.googleusercontent.com"
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static func shared() -> DataController {
        struct Singleton {
            static var shared = DataController(modelName: "TravelDiary")
        }
        return Singleton.shared
    }
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() ->Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
            
        }
    }
    
    func save() {
        try? viewContext.save()
    }
    
    func delete(location: Location) {
        try? viewContext.delete(location)
        save()
    }
    
    
}

