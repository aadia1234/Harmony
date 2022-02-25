//
//  Folder+CoreDataClass.swift
//  Harmony
//
//  Created by Aadi Anand on 2/15/22.
//
//

import SwiftUI
import CoreData

@objc(Folder)
public class Folder: Item {
    
    
    public static var parentFolders: [Folder] { Folder.getFolders(with: NSPredicate(format: "storedParentFolder == nil")) }
    public static var allFolders: [Folder] { Folder.getFolders() }
    public var documents: [Document] {
        get {
            let set = storedDocuments as? Set<Document> ?? Set<Document>()
            return set.sorted { prev, curr in
                switch DataController.sortMethod {
                    case .name: return prev.title < curr.title
                    case .date: return prev.lastOpened < curr.lastOpened
                    case .type: return String(describing: prev) < String(describing: curr)
                }
            }
        }
        set {self.storedDocuments = NSSet(array: newValue)}
    }
    public var parentFolder: Folder? { get {self.storedParentFolder ?? nil} set {self.storedParentFolder = newValue} }
    public var subFolders: [Folder]? {
        get {if let subs = self.storedSubFolders?.allObjects as? [Folder] {return subs.isEmpty ? nil : subs} else {return nil}}
        set {self.storedSubFolders = NSSet(array: newValue ?? [])}
    }
        
    public static func getFolders(with predicate: NSPredicate? = nil) -> [Folder] {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        if let predicate = predicate { request.predicate = predicate }
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
        return (parent == ancestor) ? true : parent.hasAncestor(ancestor)
    }
    
    func moveToParentFolders() {
        self.parentFolder = nil
        DataController.save()
    }
}

class MasterDirectory: ObservableObject {
    @Published var cd: Folder = Folder.parentFolders.first ?? Folder()
    @Published var doc: Item = Item()
}
