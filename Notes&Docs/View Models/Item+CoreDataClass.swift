//
//  Item+CoreDataClass.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/11/22.
//
//

import SwiftUI
import CoreData

public class Item: NSManagedObject {
    public var title: String { get {self.storedTitle ?? ""} set {self.storedTitle = newValue}}
        
    static func == (lhs: Item, rhs: Item) -> Bool { return lhs.id == rhs.id }
    
    func delete() {DataController.context.delete(self)}
    
    func move(to folder: Folder) {DataController.save()}
}
