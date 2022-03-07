//
//  Item+CoreDataClass.swift
//  Harmony
//
//  Created by Aadi Anand on 2/15/22.
//
//

import SwiftUI
import CoreData

public class Item: NSManagedObject {
    public var title: String { get {self.storedTitle ?? ""} set {self.storedTitle = newValue} }
    public var date: Date { get {self.storedDate ?? Date.now} set {self.storedDate = newValue} }
    
    public static func getItems(type itemType: Item.Type, with predicate: NSPredicate? = nil, sortBy sorts: [NSSortDescriptor]? = nil) -> [Item] {
        let request: NSFetchRequest = itemType.fetchRequest()
        request.includesSubentities = true
        let classPredicate = NSPredicate(format: "entity == %@", itemType.self.entity())
        let predicates = (predicate != nil) ? [classPredicate, predicate!] : [classPredicate]
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        if let sorts = sorts { request.sortDescriptors = sorts }
        if let results = try? DataController.context.fetch(request) { return results } else { return [] }
    }

    static func == (lhs: Item, rhs: Item) -> Bool { return lhs.id == rhs.id }
    
    func move(to folder: Folder) { DataController.save() }

    func delete() {
        DataController.context.delete(self)
        DataController.save()
    }
}
