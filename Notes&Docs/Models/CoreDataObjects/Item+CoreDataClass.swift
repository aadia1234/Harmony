//
//  Item+CoreDataClass.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/11/22.
//
//

import SwiftUI
import CoreData

public class Item: NSManagedObject, NSCopying {
    public var title: String { get {self.storedTitle ?? ""} set {self.storedTitle = newValue}}
    public static let context: NSManagedObjectContext = DataController().container.viewContext
        
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func copy(with zone: NSZone? = nil) -> Any { return Item() }
        
    func delete() {Item.context.delete(self); try! Item.context.save()}
    
    func move(to folder: Folder) {}
}
