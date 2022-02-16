//
//  Item+CoreDataProperties.swift
//  Harmony
//
//  Created by Aadi Anand on 2/15/22.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var storedId: UUID?
    @NSManaged public var storedTitle: String?

}

extension Item : Identifiable {

}
