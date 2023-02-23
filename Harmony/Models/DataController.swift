//
//  DataController.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/11/22.
//

import SwiftUI
import CoreData

class DataController: ObservableObject {
    public static let shared = DataController()
    
    let container: NSPersistentCloudKitContainer
    
    init() {
        container = NSPersistentCloudKitContainer(name: "Harmony")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    public var context: NSManagedObjectContext {
        let context = DataController.shared.container.viewContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }
    public func save() { do { try DataController.shared.context.save() } catch { print(error.localizedDescription) } }
    @AppStorage("sortFoldersMethod") public static var sortFoldersMethod: SortMethod = .title
    @AppStorage("sortDocsMethod") public static var sortDocsMethod: SortMethod = .title
}


extension NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}
