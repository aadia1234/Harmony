//
//  DirectoryView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/21/22.
//

import SwiftUI

public enum SortMethod: String, CaseIterable, Identifiable {
    case name = "name"
    case date = "date"
    case type = "type"
    
    public var id: String { self.rawValue }
}

struct DirectoryView: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var master: MasterDirectory
    @EnvironmentObject var newItemAlert: TextAlert
    @ObservedObject var directory: Folder = Folder.parentFolders.first ?? Folder()
    
    @State private var searchText = ""
    @State private var selectedDocuments = Set<Document>()
    @State private var showFileNavView = false
    @State private var showSettings = false
        
    private var isEditing: Bool { editMode?.wrappedValue == .active }
    
    
    init(directory: Folder) {
        self.directory = directory
    }
    
    var gridLayout = [GridItem(.adaptive(minimum: 280))]
    
    func menuButton(title: String, type: Item.Type) {
        newItemAlert.title = title
        newItemAlert.itemType = type
        editMode?.wrappedValue = .inactive
    }
    
    var body: some View {
        Group {
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 50) {
                    ForEach(searchResults, id: \.self) { doc in
                        FileView(doc, $selectedDocuments)
                            .environment(\.editMode, editMode)
                            .contextMenu {
                                Button {
                                    master.doc = doc
                                    menuButton(title: "What would you like to rename \"\(doc.title)\" to?", type: Document.self)
                                } label: { Label("Rename", systemImage: "character.cursor.ibeam") }
                                Button {
                                    selectedDocuments = [doc]
                                    showFileNavView = true
                                    master.doc = doc
                                } label: { Label("Move", systemImage: "rectangle.portrait.and.arrow.right") }
            
                                Button(role: .destructive) { doc.delete() } label: { Label("Delete Document", systemImage: "trash") }
                            }
                    }
                }
                .padding(.top, 50)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer)
        }
        .navigationTitle(directory.title)
        .sheet(isPresented: $showFileNavView) {FileNavigationView(items: $selectedDocuments)}
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button("Move") { showFileNavView.toggle() }
                    Spacer()
                    Button("Delete") { selectedDocuments.forEach({$0.delete()})}.tint(.red)
                }
                .transition(.slide)
                .disabled(selectedDocuments.isEmpty)
                .opacity(isEditing ? 1 : 0)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    EditButton()
                    Menu {
                        Button { menuButton(title: "Add New Note", type: Note.self) } label: { Label("New Note", systemImage: "note.text.badge.plus") }
                        Button { menuButton(title: "Add New WordPad", type: WordPad.self) } label: { Label("New WordPad", systemImage: "doc.badge.plus") }
                    } label: { Label("Add Item", systemImage: "plus") }
                    .disabled(Folder.parentFolders.isEmpty || editMode!.wrappedValue.isEditing)
                    .onTapGesture { master.cd = directory }
                    
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .popover(isPresented: $showSettings) {
                        VStack {
                            Section("Sort by") {
                                Picker("Sort", selection: Binding(
                                    get: {
                                        DataController.sortDocumentsBy
                                    },
                                    set: { value in
                                        DataController.sortDocumentsBy = value
                                        directory.documents = directory.documents
                                    }))
                                {
                                    ForEach(SortMethod.allCases, id: \.id) { sort in
                                        Text(sort.rawValue.capitalized)
                                            .tag(sort)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            .font(.title2)
                            
                        }
                        .padding()
                        .frame(width: 300, height: 100, alignment: .center)
                        
                    }
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
            .environmentObject(TextAlert(title: ""))
            .environmentObject(MasterDirectory())
            .previewInterfaceOrientation(.landscapeRight)
    }
}
