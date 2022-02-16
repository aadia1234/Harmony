//
//  WordPad+CoreDataProperties.swift
//  Harmony
//
//  Created by Aadi Anand on 2/15/22.
//
//

import Foundation
import CoreData


extension WordPad {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordPad> {
        return NSFetchRequest<WordPad>(entityName: "WordPad")
    }

    @NSManaged public var storedText: String?

}
