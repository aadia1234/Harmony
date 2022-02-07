//
//  Document.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/1/22.
//

import SwiftUI

class Document: Item {
    @Published var preview = Image(systemName: "pencil")
    @Published var lastOpened = Date.now
    
    override func delete() {
        let folder = Folder.allFolders.first(where: {$0.documents.contains(where: {$0 == self})})
        folder?.documents.removeAll(where: {$0 == self})
    }
}
