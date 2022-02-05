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
}
