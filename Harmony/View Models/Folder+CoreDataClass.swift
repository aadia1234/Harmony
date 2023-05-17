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
    
    
    public static var parentFolders: [Folder] {
        let key = "stored\(DataController.sortFoldersMethod.rawValue.capitalized)"
        let sorts = [NSSortDescriptor(key: key, ascending: true)]
        return Item.getItems(type: Folder.self, with: NSPredicate(format: "storedParentFolder == nil"), sortBy: sorts) as! [Folder]
    }
    public static var allFolders: [Folder] { Folder.getItems(type: Folder.self) as! [Folder] }
    public var documents: [DocumentType] {
        get {
            let set = storedDocuments as? Set<DocumentType> ?? Set<DocumentType>()
            return set.sorted { prev, curr in
                switch DataController.sortDocsMethod {
                    case .title: return prev.title < curr.title
                    case .date:
                        if prev.date == curr.date {
                            return prev.title < curr.title
                        } else {
                            return prev.date > curr.date
                        }
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
        
    
//    
    convenience required init() {
        self.init(entity: Folder.entity(), insertInto: nil)
        self.title = "New Folder"
    }
    
    convenience init(title: String, parentFolder: Folder?, documents: [DocumentType], subFolders: [Folder]?) {
        self.init(context: DataController.shared.context)
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
        DataController.shared.save()
    }
}

class MasterDirectory: ObservableObject {
    @Published var cd: Folder = Folder.parentFolders.first ?? Folder()
    @Published var doc: Item?
}
