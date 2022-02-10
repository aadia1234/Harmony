//
//  WordProcessor.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/1/22.
//

import SwiftUI

class WordPad: Document {
    @Published var text = ""
    
    override init() {}
    
    init(title: String, preview: Image, lastOpened: Date, text: String) {
        super.init()
        self.title = title
        self.preview = preview
        self.lastOpened = lastOpened
        self.text = text
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        return WordPad(title: self.title, preview: self.preview, lastOpened: self.lastOpened, text: self.text)
    }
    
    override func move(to folder: Folder) {
        let copy = self.copy() as! WordPad
        folder.documents.append(copy)
        self.delete()
    }
}
