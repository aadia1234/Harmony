//
//  Folder+CoreDataProperties.swift
//  Harmony
//
//  Created by Aadi Anand on 2/15/22.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var storedDocuments: NSSet?
    @NSManaged public var storedParentFolder: Folder?
    @NSManaged public var storedSubFolders: NSSet?

}

// MARK: Generated accessors for storedDocuments
extension Folder {

    @objc(addStoredDocumentsObject:)
    @NSManaged public func addToStoredDocuments(_ value: Document)

    @objc(removeStoredDocumentsObject:)
    @NSManaged public func removeFromStoredDocuments(_ value: Document)

    @objc(addStoredDocuments:)
    @NSManaged public func addToStoredDocuments(_ values: NSSet)

    @objc(removeStoredDocuments:)
    @NSManaged public func removeFromStoredDocuments(_ values: NSSet)

}

// MARK: Generated accessors for storedSubFolders
extension Folder {

    @objc(addStoredSubFoldersObject:)
    @NSManaged public func addToStoredSubFolders(_ value: Folder)

    @objc(removeStoredSubFoldersObject:)
    @NSManaged public func removeFromStoredSubFolders(_ value: Folder)

    @objc(addStoredSubFolders:)
    @NSManaged public func addToStoredSubFolders(_ values: NSSet)

    @objc(removeStoredSubFolders:)
    @NSManaged public func removeFromStoredSubFolders(_ values: NSSet)

}
