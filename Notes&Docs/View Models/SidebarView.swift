//
//  SidebarView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/21/22.
//

import SwiftUI

struct SidebarView: View {
    
    @Environment(\.editMode) var mode
    @EnvironmentObject var updateView: UpdateView
    @ObservedObject var newDirAlert: TextAlert
    @EnvironmentObject var master: MasterDirectory
    @State private var searchText = ""
    @State private var selection = Set<Folder>()
    
    
    init(alert newDirAlert: TextAlert) {
        self.newDirAlert = newDirAlert
    }
    
    var body: some View {
        Group {
            List(searchResults, id: \.self, children: \.children, selection: $selection) { folder in
                NavigationLink(destination: DirectoryView(directory: folder)) {
                    Label(folder.title, systemImage: "folder")
                }
                .swipeActions {
                    Button(role: .destructive) {
                        folder.delete()
                    } label: {
                        Text("Delete")
                    }
                }
            }
            .searchable(text: $searchText)
            .opacity(updateView.didUpdate ? 0 : 1)
            .onChange(of: mode?.wrappedValue == .inactive) { _ in selection.removeAll() }
            
            NavigationLink(isActive: $newDirAlert.showNewItem) {
                DirectoryView(directory: Folder.parentDirectories.last ?? Folder())
            } label: {
                EmptyView()
            }
        }
        .navigationTitle("Folders")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItemGroup(placement: .bottomBar) {
                if mode?.wrappedValue == .active {
                    Button(role: .destructive) {
                        selection.forEach{$0.delete()}
                        updateView.update()
                        
                    } label: {
                        Label("Delete Folder", systemImage: "trash")
                    }
                } else {
                    Button {
                        newDirAlert.item = Folder()
                        newDirAlert.item.title = ""
                        newDirAlert.visibility = true
                        newDirAlert.showNewItem = false
                    } label: {
                        Label("New Directory", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    var searchResults: [Folder] {
        if searchText.isEmpty {
            return Folder.parentDirectories
        } else {
            return Folder.allFolders.filter({ $0.title.contains(searchText) })
        }
        
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(alert: TextAlert(title: ""))
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(TextAlert(title: ""))
            .environmentObject(UpdateView())
    }
}
