//
//  UpdateView.swift
//  Harmony
//
//  Created by Aadi Anand on 3/5/22.
//

import SwiftUI

class UpdateView: ObservableObject {
    @Published var didUpdate = false
    
    func update() {
        didUpdate.toggle()
        didUpdate.toggle()
    }
}
