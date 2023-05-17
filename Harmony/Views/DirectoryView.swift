//
//  DirectoryView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/21/22.
//

import SwiftUI

struct DirectoryView: View {
    @State private var editMode: EditMode = .inactive
    @EnvironmentObject var master: MasterDirectory
    @EnvironmentObject var newItemAlert: TextAlert
    @ObservedObject var directory: Folder
        // Folder.parentFolders.first ?? Folder()
    
    @State private var searchText = ""
    @State private var selectedDocuments = Set<DocumentType>()
    @State private var showFileNavView = false
    @State private var showSettings = false
    @Binding private var sortFoldersSelection: SortMethod
    @Binding private var sortDocsSelection: SortMethod
        
    private var isEditing: Bool { $editMode.wrappedValue == .active }
    private var gridLayout = [GridItem(.adaptive(minimum: 280))]

    init(directory: Folder) {
        self.directory = directory
        self._sortFoldersSelection = Binding(
            get: { DataController.sortFoldersMethod },
            set: { DataController.sortFoldersMethod = $0 }
        )
        
        self._sortDocsSelection = Binding(
            get: { DataController.sortDocsMethod },
            set: { value in DataController.sortDocsMethod = value }
        )
    }
    
    func setAlert(title: String, type: Item.Type) {
        newItemAlert.title = title
        newItemAlert.itemType = type
        $editMode.wrappedValue = .inactive
    }
    
    var searchResults: [DocumentType] {
        if searchText.isEmpty {
            return directory.documents
        } else {
            return directory.documents.filter({ $0.title.contains(searchText) })
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout, spacing: 50) {
                ForEach(searchResults, id: \.self) { doc in
                    FileView(doc, $selectedDocuments, Binding(get: {
                        isEditing
                    }, set: { Value in
                        editMode = Value ? .active : .inactive
                    }))
                        .contextMenu {
                            LabelButton(title: "Rename", image: "character.cursor.ibeam") {
                                master.doc = doc
                                setAlert(title: "What would you like to rename \"\(doc.title)\" to?", type: DocumentType.self)
                            }
                            
                            LabelButton(title: "Move", image: "rectangle.portrait.and.arrow.right") {
                                selectedDocuments = [doc]
                                showFileNavView = true
                                master.doc = doc
                            }
                            
                            LabelButton(title: "Delete Document", image: "trash", role: .destructive) { doc.delete() }
                        }
                }
            }
            .padding(.top, 50)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
        .navigationTitle(directory.title)
        .onDisappear {
            directory.date = Date.now
            DataController.shared.save()
        }
        .sheet(isPresented: $showFileNavView) {FileNavigationView(items: $selectedDocuments)}
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    LabelButton(title: "Move") {
                        showFileNavView.toggle()
                    }
                    Spacer()
                    LabelButton(title: "Delete", role: .destructive) { selectedDocuments.forEach({$0.delete()}) }
                }
                .transition(.slide)
                .disabled(selectedDocuments.isEmpty)
                .opacity(isEditing ? 1 : 0)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(isEditing ? "Done" : "Edit") {
                        editMode = isEditing ? .inactive : .active
                    }
                    Menu {
                        LabelButton(title: "New Note", image: "note.text.badge.plus") { setAlert(title: "Add New Note", type: Note.self) }
                        LabelButton(title: "New WordPad", image: "doc.badge.plus") { setAlert(title: "Add New WordPad", type: WordPad.self) }
                    } label: { Label("Add Item", systemImage: "plus") }
                    .disabled(Folder.parentFolders.isEmpty || isEditing)
                    .onTapGesture { master.cd = directory }
                    
                    LabelButton(title: "Settings", image: "gearshape") { showSettings = true }
                    .popover(isPresented: $showSettings) {
                        VStack {
                            Section("Sort Folders by") {
                                Picker("Sort Folders", selection: $sortFoldersSelection) {
                                    ForEach(SortMethod.allCases) { sort in
                                        if sort != .type { Text(sort.rawValue.capitalized).tag(sort) }
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            .font(.title3)
                            
                            Spacer()
                            
                            Section("Sort Documents by") {
                                Picker("Sort Documents", selection: $sortDocsSelection) {
                                    ForEach(SortMethod.allCases) { sort in
                                        Text(sort.rawValue.capitalized).tag(sort)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            .font(.title3)
                        }
                        .padding()
                        .frame(width: 300, height: 212.5, alignment: .center)
                        
                    }
                }
            }
        }
    }
}

//struct DirectoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        DirectoryView(directory: Folder())
//            .environmentObject(TextAlert(title: ""))
//            .environmentObject(MasterDirectory())
//            .previewInterfaceOrientation(.landscapeRight)
//    }
//}
