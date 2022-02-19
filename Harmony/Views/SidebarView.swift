//
//  SidebarView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/21/22.
//

class Search: ObservableObject {
    var results: [Folder] { Folder.parentFolders }
}

import SwiftUI

struct SidebarView: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var master: MasterDirectory
    @ObservedObject var newDirAlert: TextAlert
    @ObservedObject private var search = Search()

    @State private var selection = Set<Folder>()
    @State private var showFileNavView = false
    @State private var searchText = ""
    
    private var results: [Folder] {
        if searchText.isEmpty {
            return search.results
        } else {
            return search.results.filter({$0.title.contains(searchText)})
        }
    }
    
    private var isEditing: Bool { editMode?.wrappedValue == .active }
    
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
                            Button {
                                master.cd = folder
                                menuButton(title: "Add new sub folder")
                            } label: {
                                Label("Add new subfolder", systemImage: "square.grid.3x1.folder.badge.plus")
                            }
                            
                            Button {
                                master.cd = folder
                                menuButton(title: "What would you like to rename \"\(folder.title)\" to?")
                            } label: {
                                Label("Rename Folder", systemImage: "character.cursor.ibeam")
                            }
                            
                            Button {
                                selection = [folder]
                                showFileNavView.toggle()
                            } label: {
                                Label("Move Folder", systemImage: "rectangle.portrait.and.arrow.right")
                            }

                            Button(role: .destructive) {
                                search.objectWillChange.send()
                                selection = [folder]
                                selection.forEach{$0.delete()}
                            } label: {
                                Label("Delete Folder", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .listStyle(.automatic)
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
                        Button("Move") { showFileNavView.toggle() }
                        Spacer()
                        Button("Delete") {
                            search.objectWillChange.send()
                            selection.forEach{$0.delete()}
                        }
                        .tint(.red)
                    }
                    .disabled(selection.isEmpty)
                    .opacity(isEditing ? 1 : 0)
                    
                    Button {
                        newDirAlert.title = "Add new folder"
                        newDirAlert.itemType = Folder.self
                    } label: {
                        Label("New Folder", systemImage: "plus")
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
