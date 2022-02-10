//
//  Document.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/19/22.
//

import SwiftUI
import PencilKit

class Note: Document {
    @Published var drawing = PKCanvasView().drawing
    
    override init() {}
    
    init(title: String, preview: Image, lastOpened: Date, drawing: PKDrawing) {
        super.init()
        self.title = title
        self.preview = preview
        self.lastOpened = lastOpened
        self.drawing = drawing
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        return Note(title: self.title, preview: self.preview, lastOpened: self.lastOpened, drawing: self.drawing)
    }
    
    override func move(to folder: Folder) {
        let copy = self.copy() as! Note
        folder.documents.append(copy)
        self.delete()
    }
}
