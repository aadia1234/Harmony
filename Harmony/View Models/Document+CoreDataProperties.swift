//
//  Document+CoreDataProperties.swift
//  Harmony
//
//  Created by Aadi Anand on 2/15/22.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var storedLastOpened: Date?
    @NSManaged public var storedThumbnailData: Data?
    @NSManaged public var storedFolder: Folder?

}
