//
//  Folder+CoreDataClass.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/11/22.
//
//

import SwiftUI
import CoreData

@objc(Folder)
public class Folder: Item {
    
    public static var parentFolders: [Folder] {
        Folder.getFolders(with: NSPredicate(format: "storedParentFolder == nil"))
    }
    public static var allFolders: [Folder] {
        Folder.getFolders()
    }
    
    public var documents: [Document] {
        get { let set = storedDocuments as? Set<Document> ?? Set<Document>(); return set.sorted { $0.title > $1.title }}
        set {self.storedDocuments = NSSet(array: newValue); print("val: \(newValue)")}
    }
    public var parentFolder: Folder? { get {self.storedParentFolder ?? nil} set {self.storedParentFolder = newValue}}
    public var subFolders: [Folder]? {
        get { if let subs = self.storedSubFolders?.allObjects as? [Folder] { return subs.isEmpty ? nil : subs } else { return nil } }
        set { self.storedSubFolders = NSSet(array: newValue ?? []) }
    }
        
    public static func getFolders(with predicate: NSPredicate? = nil) -> [Folder] {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        if predicate != nil { request.predicate = predicate }
        if let results = try? DataController.context.fetch(request) { return results } else { return [] }
        
    }
    
    convenience init() {
        self.init(entity: Folder.entity(), insertInto: nil)
        self.title = "New Folder"
    }
    
    convenience init(title: String, parentFolder: Folder?, documents: [Document], subFolders: [Folder]?) {
        self.init(context: DataController.context)
        self.title = title
        self.parentFolder = parentFolder
        self.documents = documents
        self.subFolders = subFolders
    }
    
    override func move(to folder: Folder) {
        if folder.subFolders == nil { folder.subFolders = [] }
        self.parentFolder = folder
        super.move(to: folder)
    }
    
    func hasAncestor(_ ancestor: Folder) -> Bool {
        guard let parent = self.parentFolder else { return false }
        if parent == ancestor {
            return true
        } else {
            return parent.hasAncestor(ancestor)
        }
    }
    
    func moveToParentFolders() {
        self.parentFolder = nil
        DataController.save()
    }
}

class MasterDirectory: ObservableObject {
    @Published var cd = Folder.parentFolders.first ?? Folder()
}
