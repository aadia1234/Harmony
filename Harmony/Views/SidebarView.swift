//
//  SidebarView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/21/22.
//

import SwiftUI

struct SidebarView: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var master: MasterDirectory
    @ObservedObject var newDirAlert: TextAlert

    @State private var selection = Set<Folder>()
    @State private var showFileNavView = false
    @State private var searchText = ""
    
    private var isEditing: Bool { editMode?.wrappedValue == .active }

    private var results: [Folder] {
        get {
            if searchText.isEmpty {
                return Folder.parentFolders
            } else {
                return Folder.parentFolders.filter({$0.title.contains(searchText)})
            }
        }
        set {searchText = ""}
    }
    
    
    init(alert newDirAlert: TextAlert) {
        self.newDirAlert = newDirAlert
    }
    
    func menuButton(title: String) {
        newDirAlert.title = title
        newDirAlert.itemType = Folder.self
        editMode?.wrappedValue = .inactive
    }
    
    var body: some View {
        Group {
            List(results, id: \.self, children: \.subFolders, selection: $selection) { folder in
                ZStack {
                    HStack {
                        Label(folder.title, systemImage: "folder")
                        Spacer()
                        NavigationLink(destination: DirectoryView(directory: folder)) { EmptyView() }
                        .frame(width: 0)
                        .opacity(0)
                    }
                    .contextMenu {
                        if !isEditing {
                            Text("Last Accessed: \(folder.date, format: .dateTime.day().month().year())")
                            LabelButton(title: "Add new subfolder", image: "square.grid.3x1.folder.badge.plus") {
                                master.cd = folder
                                menuButton(title: "Add new sub folder")
                            }
                            
                            LabelButton(title: "Rename Folder", image: "character.cursor.ibeam") {
                                master.cd = folder
                                menuButton(title: "What would you like to rename \"\(folder.title)\" to?")
                            }
                            
                            LabelButton(title: "Move Folder", image: "rectangle.portrait.and.arrow.right") {
                                selection = [folder]
                                showFileNavView.toggle()
                            }
                            
                            LabelButton(title: "Delete Folder", image: "trash", role: .destructive) {
                                selection = [folder]
                                selection.forEach{$0.delete()}
                            }
                        }
                    }.id(folder.date)
                    
                }
            }
            .animation(Animation.easeInOut(duration: 0), value: isEditing)
            .listStyle(.sidebar)
            .searchable(text: $searchText)
            NavigationLink(isActive: $newDirAlert.showNewItem) { DirectoryView(directory: Folder.parentFolders.last ?? Folder()) } label: { EmptyView() }
        }
        .navigationTitle("Folders")
        .sheet(isPresented: $showFileNavView) {FileNavigationView(items: $selection)}
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
            ToolbarItemGroup(placement: .bottomBar) {
                ZStack {
                    HStack {
                        LabelButton(title: "Move") { showFileNavView.toggle() }
                        Spacer()
                        LabelButton(title: "Delete", role: .destructive) {
                            selection.forEach{$0.delete()}
                            editMode?.wrappedValue = .inactive
                        }
                    }
                    .disabled(selection.isEmpty)
                    .opacity(isEditing ? 1 : 0)
                    
                    LabelButton(title: "New Folder", image: "plus") {
                        newDirAlert.title = "Add new folder"
                        newDirAlert.itemType = Folder.self
                    }
                    .opacity(isEditing ? 0 : 1)
                }

            }
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(alert: TextAlert(title: ""))
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(TextAlert(title: ""))
    }
}
