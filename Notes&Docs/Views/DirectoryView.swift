//
//  DirectoryView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/21/22.
//

import SwiftUI

struct DirectoryView: View {
    
    @Environment(\.editMode) var editMode
    @EnvironmentObject var updateView: UpdateView
    @EnvironmentObject var master: MasterDirectory
    @EnvironmentObject var newItemAlert: TextAlert
    @ObservedObject var directory: Folder = Folder.parentFolders.first ?? Folder()
    
    @State private var searchText = ""
    @State private var selectedDocuments = Set<Document>()
    @State private var showFileNavView = false
    
    private var isEditing: Bool { editMode?.wrappedValue == .active }
    
    
    init(directory: Folder) {
        self.directory = directory
    }
    
    var gridLayout = [GridItem(.adaptive(minimum: 280))]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 50) {
                    ForEach(searchResults, id: \.self) { doc in
                        FileView(doc, $selectedDocuments)
                            .environment(\.editMode, editMode)
                    }
                }
                .padding(.top, 50)
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
        .navigationTitle(directory.title)
        .opacity(updateView.didUpdate ? 0 : 1)
        .sheet(isPresented: $showFileNavView) {FileNavigationView(items: $selectedDocuments)}
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                HStack {
                    Button("Move") { showFileNavView.toggle() }
                    Spacer()
                    Button(role: .destructive) { selectedDocuments.forEach({$0.delete()}) } label: { Text("Delete") }
                }
                .opacity(isEditing ? 1 : 0)
                
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Group {
                    EditButton()
                    
                    Menu {
                        Button { newItemAlert.itemType = Folder.self } label: { Label("New Folder", systemImage: "folder.badge.plus") }
                        Button { newItemAlert.itemType = Note.self } label: { Label("New Note", systemImage: "note.text.badge.plus") }
                        Button { newItemAlert.itemType = WordPad.self } label: { Label("New WordPad", systemImage: "doc.badge.plus") }
                    } label: { Label("Add Item", systemImage: "plus") }
                    .disabled(Folder.parentFolders.isEmpty || editMode!.wrappedValue.isEditing)
                    .onTapGesture { master.cd = directory }
                }
            }
        }
    }
    
    var searchResults: [Document] {
        if searchText.isEmpty {
            return directory.documents
        } else {
            return directory.documents.filter({ $0.title.contains(searchText) })
        }
    }
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView(directory: Folder())
            .environmentObject(UpdateView())
            .environmentObject(TextAlert(title: ""))
            .environmentObject(MasterDirectory())
            .previewInterfaceOrientation(.landscapeRight)
    }
}
