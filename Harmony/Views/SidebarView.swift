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
    @EnvironmentObject var master: MasterDirectory
    
    @ObservedObject var newDirAlert: TextAlert
    @State private var searchText = ""
    @State private var selection = Set<Folder>()
    @State private var showFileNavView = false
    
    private var isEditing: Bool { editMode?.wrappedValue == .active }
    
    init(alert newDirAlert: TextAlert) { self.newDirAlert = newDirAlert }
    
    var body: some View {
        Group {
            List(searchResults, id: \.self, children: \.subFolders, selection: $selection) { folder in
                Label(folder.title, systemImage: "folder")
                .swipeActions {
                    Button(role: .destructive) { folder.delete() } label: { Label("Delete", systemImage: "trash") }
                    Button {} label: { Label("Move", systemImage: "rectangle.portrait.and.arrow.right") }
                }
                
                NavigationLink(destination: DirectoryView(directory: folder)) { EmptyView() }
                .frame(width: 0)
                .opacity(0)
            }
            .listStyle(.automatic)
            .searchable(text: $searchText)
            .opacity(updateView.didUpdate ? 0 : 1)
            NavigationLink(isActive: $newDirAlert.showNewItem) { DirectoryView(directory: Folder.parentFolders.last ?? Folder()) } label: { EmptyView() }
        }
        .navigationTitle("Folders")
        .sheet(isPresented: $showFileNavView) {FileNavigationView(items: $selection)}.onAppear{print("count: \(selection.count)")}
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
            ToolbarItemGroup(placement: .bottomBar) {
                ZStack {
                    HStack {
                        Button("Move") { showFileNavView.toggle() }
                        Spacer()
                        Button("Delete") {
                            selection.forEach{$0.delete()}
                            updateView.update()
                        }
                        .tint(.red)
                    }
                    .disabled(selection.isEmpty)
                    .opacity(isEditing ? 1 : 0)
                    
                    Button {
                        newDirAlert.itemType = Folder.self
                    } label: { Label("New Directory", systemImage: "plus") }
                    .opacity(isEditing ? 0 : 1)
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

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(alert: TextAlert(title: ""))
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(TextAlert(title: ""))
            .environmentObject(UpdateView())
    }
}
