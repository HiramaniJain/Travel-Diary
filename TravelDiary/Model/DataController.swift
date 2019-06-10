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
import MapKit

class DataController {
    let persistentContainer:NSPersistentContainer
    
    var userName:String!
    
    func setUserName(user: String) {
        userName = user
    }
    
    func getTitle() -> String {
        let title = "\(userName ?? "") \(" Diary")"
        return title
    }
    
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

