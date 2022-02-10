//
//  SidebarView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/21/22.
//

import SwiftUI

struct SidebarView: View {
    
    @Environment(\.editMode) var editMode
    @EnvironmentObject var updateView: UpdateView
    @ObservedObject var newDirAlert: TextAlert
    @EnvironmentObject var master: MasterDirectory
    @State private var searchText = ""
    @State private var selection = Set<Folder>()
    @State private var showFileNavView = false
    
    init(alert newDirAlert: TextAlert) {
        self.newDirAlert = newDirAlert
    }
    
    var body: some View {
        Group {
            List(searchResults, id: \.self, children: \.subFolders, selection: $selection) { folder in
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
            NavigationLink(isActive: $newDirAlert.showNewItem) {
                DirectoryView(directory: Folder.parentFolders.last ?? Folder())
            } label: {
                EmptyView()
            }
        }
        .navigationTitle("Folders")
        .sheet(isPresented: $showFileNavView) {FileNavigationView(items: $selection)}
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItemGroup(placement: .bottomBar) {
                ZStack {
                    HStack {
                        Button {
                            showFileNavView.toggle()
                        } label: {
                            Text("Move")
                        }
                        .disabled(selection.isEmpty)
                        
                        
                        Spacer()
                        
                        Button(role: .destructive) {
                            selection.forEach{$0.delete()}
                            updateView.update()

                        } label: {
                            Text("Delete")
                                .tint(.red)
                        }
                    }
                    .opacity(editMode?.wrappedValue == .active ? 1 : 0)
                    
                    Button {
                        newDirAlert.item = Folder()
                        newDirAlert.item.title = ""
                        newDirAlert.visibility = true
                        newDirAlert.showNewItem = false
                    } label: {
                        Label("New Directory", systemImage: "plus")
                    }
                    .opacity(editMode?.wrappedValue == .inactive ? 1 : 0)
                }
            }
        }
    }
    
    var searchResults: [Folder] {
        if searchText.isEmpty {
            return Folder.parentFolders
        } else {
            return Folder.allFolders.filter({ $0.title.contains(searchText) })
        }
        
    }
}


// https://www.youtube.com/watch?v=cR_5lbb0yss
//            List {
//                ForEach(searchResults) { folder in
//                    DisclosureGroup("\(folder.title)") {
//                        OutlineGroup(folder.subFolders ?? [Folder](), children: \.subFolders) { subFolder in
//                            if subFolder.subFolders == nil {
//                                NavigationLink(destination: DirectoryView(directory: subFolder)) {
//                                    Label(subFolder.title, systemImage: "folder")
//                                }
//                            } else {
//                                Label(subFolder.title, systemImage: "folder")
//                            }
//                        }
//                    }
//                }
//
//            }


struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(alert: TextAlert(title: ""))
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(TextAlert(title: ""))
            .environmentObject(UpdateView())
    }
}
