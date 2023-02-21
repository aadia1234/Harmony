//
//  DataController.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/11/22.
//

import SwiftUI
import CoreData

class DataController {
    public static let container = NSPersistentCloudKitContainer(name: "Harmony")
    public static var context: NSManagedObjectContext {
        let context = DataController.container.viewContext
        DataController.container.loadPersistentStores { description, error in
            if let error = error {
//                print("Core Data failed to load: \(error.localizedDescription)")
            }
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
        }
        return context
    }
    public static func save() { do { try DataController.context.save() } catch { print(error.localizedDescription) } }
    @AppStorage("sortFoldersMethod") public static var sortFoldersMethod: SortMethod = .title
    @AppStorage("sortDocsMethod") public static var sortDocsMethod: SortMethod = .title
}
