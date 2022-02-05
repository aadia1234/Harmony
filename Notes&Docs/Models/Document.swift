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
}
