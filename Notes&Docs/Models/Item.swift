//
//  Item.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/4/22.
//

import SwiftUI

protocol DeleteProtocol: Item {
    func delete()
}

class Item: Identifiable, ObservableObject, DeleteProtocol, Hashable {
    @Published var title = ""
    @Published var id = UUID()
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    func delete() {}
}
