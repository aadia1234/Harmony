//
//  Directory.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/22/22.
//

import Foundation

class Directory: Item {
    public static var allDirectories: [Directory] = [Directory()]
    @Published var items: [Item] = []
    
    override init() {
        super.init()
        title = "New Directory"
    }
}

class MasterDirectory: ObservableObject {
    @Published var cd = Directory.allDirectories.first!
}
