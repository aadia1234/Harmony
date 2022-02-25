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
        
    static func == (lhs: Item, rhs: Item) -> Bool { return lhs.id == rhs.id }
    
    func move(to folder: Folder) { DataController.save() }

    func delete() {
        DataController.context.delete(self)
        DataController.save()
    }
}
