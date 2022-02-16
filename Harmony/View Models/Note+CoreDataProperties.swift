//
//  Note+CoreDataProperties.swift
//  Harmony
//
//  Created by Aadi Anand on 2/15/22.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var storedDrawingData: Data?

}
