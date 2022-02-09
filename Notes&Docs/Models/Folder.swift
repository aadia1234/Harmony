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
    
    override func delete() {
        Folder.parentFolders.removeAll(where: {$0.id == self.id})
        Folder.allFolders.removeAll(where: {$0.id == self.id})
        let parent = Folder.allFolders.first(where: {$0.subFolders?.contains(where: {$0.id == self.id}) ?? false})
        parent?.subFolders?.removeAll(where: {$0.id == self.id})
    }
}

class MasterDirectory: ObservableObject {
    @Published var cd = Folder.parentFolders.first!
}
