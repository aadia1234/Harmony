//
//  Notes_DocsApp.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI
import CoreData

@main
struct Harmony: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    DataController.container.loadPersistentStores { description, error in
                        if let error = error {
                            print("Core Data failed to load: \(error.localizedDescription)")
                        }
                        DataController.context = DataController.container.viewContext
                        DataController.context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                    }
                }
        }
    }
}


