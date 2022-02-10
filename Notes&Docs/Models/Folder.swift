//
//  Directory.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/22/22.
//

import Foundation

class Folder: Item {
    public static var parentFolders: [Folder] = [Folder()]
    public static var allFolders: [Folder] = []
    @Published var documents: [Document] = []
    @Published var subFolders: [Folder]?
    
    override init() {
        super.init()
        self.title = "New Folder"
        Folder.allFolders.append(self)
    }
    
    init(title: String, documents: [Document], subFolders: [Folder]?) {
        super.init()
        self.title = title
        self.documents = documents
        self.subFolders = subFolders
        Folder.allFolders.append(self)
    }
    
    func getParent() -> Folder? {
        return Folder.allFolders.first(where: {$0.subFolders?.contains(self) ?? false})
    }
    
    override func delete() {
        Folder.parentFolders.removeAll(where: {$0 == self})
        Folder.allFolders.removeAll(where: {$0 == self})
        self.subFolders?.removeAll()
        self.getParent()?.subFolders?.removeAll(where: {$0 == self})
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        return Folder(title: self.title, documents: self.documents, subFolders: self.subFolders)
    }
    
    override func move(to folder: Folder) {
        if folder.subFolders == nil { folder.subFolders = [] }
        let copy = self.copy() as! Folder
        folder.subFolders?.append(copy)
        self.delete()
        print(copy.documents)
    }
    
    func hasAncestor(_ ancestor: Folder) -> Bool {
        guard let parent = self.getParent() else { return false }
        if parent == ancestor {
            return true
        } else {
            return parent.hasAncestor(ancestor)
        }
    }
    
    func moveToParentFolders() {
        let copy = self.copy() as! Folder
        Folder.parentFolders.append(copy)
        self.delete()
    }
}

class MasterDirectory: ObservableObject {
    @Published var cd = Folder.parentFolders.first!
}
