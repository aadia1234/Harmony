//
//  Directory.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/22/22.
//

import Foundation

class Folder: Item {
    public static var parentDirectories: [Folder] = [Folder()]
    public static var allFolders: [Folder] = []
    @Published var documents: [Document] = []
    @Published var children: [Folder]?
    
    override init() {
        super.init()
        self.title = "New Folder"
        Folder.allFolders.append(self)
    }
    
    override func delete() {
        Folder.parentDirectories.removeAll(where: {$0.id == self.id})
        Folder.allFolders.removeAll(where: {$0.id == self.id})
        let parent = Folder.allFolders.first(where: {$0.children?.contains(where: {$0.id == self.id}) ?? false})
        parent?.children?.removeAll(where: {$0.id == self.id})
    }
}

class MasterDirectory: ObservableObject {
    @Published var cd = Folder.parentDirectories.first!
}
