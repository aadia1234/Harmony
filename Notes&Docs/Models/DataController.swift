//
//  DataController.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/11/22.
//

import SwiftUI
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Item")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}