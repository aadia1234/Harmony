//
//  UpdateView.swift
//  Harmony
//
//  Created by Aadi Anand on 3/5/22.
//

import SwiftUI

class UpdateView: ObservableObject {
    @Published var didUpdate = false
    @Published var enableSidebar = true
    @Published var showFileNavView = false
    @Published var sidebar = SidebarView(alert: TextAlert(title: ""))
    @Published var folderNavigationView = FolderNavigationView()
    @Published var sidebarSelection = Set<Folder>()
    
    func update() {
        didUpdate.toggle()
        didUpdate.toggle()
    }
}
