//
//  TextAlert.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/22/22.
//

import Foundation

class TextAlert: ObservableObject {
    @Published var title: String = ""
    @Published var visibility: Bool = false
    @Published var showNewItem: Bool = false
    @Published var item: Item = Item()
    
    init(title: String) {
        self.title = title
    }
}
