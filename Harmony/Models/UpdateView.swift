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
    @Published var showEditorAlert = false
    @Published var editorAlert: InsertLinkView = InsertLinkView(url: .constant(""), displayText: .constant(""))
    func update() {
        didUpdate.toggle()
        didUpdate.toggle()
    }
    
    func changeNavigationBarAppearance() {
//        let coloredAppearance = UINavigationBarAppearance()
//        UINavigationBar.appearance().standardAppearance = coloredAppearance
//        UINavigationBar.appearance().compactAppearance = coloredAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
}
