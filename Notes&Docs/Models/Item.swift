//
//  Item.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/4/22.
//

import SwiftUI

class Item: Identifiable, ObservableObject {
    @Published var title = ""
    @Published var id = UUID()
}
