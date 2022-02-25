//
//  DirectoryView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/21/22.
//

import SwiftUI

struct DirectoryView: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var master: MasterDirectory
    @EnvironmentObject var newItemAlert: TextAlert
    @ObservedObject var directory: Folder = Folder.parentFolders.first ?? Folder()
    
    @State private var searchText = ""
    @State private var selectedDocuments = Set<Document>()
    @State private var showFileNavView = false
    @State private var showSettings = false
    @Binding private var sortSelection: SortMethod
        
    private var isEditing: Bool { editMode?.wrappedValue == .active }
    private var gridLayout = [GridItem(.adaptive(minimum: 280))]

    init(directory: Folder) {
        self.directory = directory
        self._sortSelection = Binding(
            get: { DataController.sortMethod },
            set: { value in DataController.sortMethod = value; directory.documents = directory.documents }
        )
    }
    
    func setButton(title: String, type: Item.Type) {
        newItemAlert.title = title
        newItemAlert.itemType = type
        editMode?.wrappedValue = .inactive
    }
    
    var searchResults: [Document] {
        if searchText.isEmpty {
            return directory.documents
        } else {
            return directory.documents.filter({ $0.title.contains(searchText) })
        }
    }
    
    var body: some View {
        Group {
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 50) {
                    ForEach(searchResults, id: \.self) { doc in
                        FileView(doc, $selectedDocuments)
                            .environment(\.editMode, editMode)
                            .contextMenu {
                                LabelButton(title: "Rename", image: "character.cursor.ibeam") {
                                    master.doc = doc
                                    setButton(title: "What would you like to rename \"\(doc.title)\" to?", type: Document.self)
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
        }
        .navigationTitle(directory.title)
        .sheet(isPresented: $showFileNavView) {FileNavigationView(items: $selectedDocuments)}
        .toolbar {
            ToolbarItem(placement: isEditing ? .bottomBar : .navigation) {
                HStack {
                    LabelButton(title: "Move") { showFileNavView.toggle() }
                    Spacer()
                    LabelButton(title: "Delete", role: .destructive) { selectedDocuments.forEach({$0.delete()}) }
                }
                .transition(.slide)
                .disabled(selectedDocuments.isEmpty)
                .opacity(isEditing ? 1 : 0)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    EditButton()
                    Menu {
                        LabelButton(title: "New Note", image: "note.text.badge.plus") { setButton(title: "Add New Note", type: Note.self) }
                        LabelButton(title: "New WordPad", image: "doc.badge.plus") { setButton(title: "Add New WordPad", type: WordPad.self) }
                    } label: { Label("Add Item", systemImage: "plus") }
                    .disabled(Folder.parentFolders.isEmpty || editMode!.wrappedValue.isEditing)
                    .onTapGesture { master.cd = directory }
                    
                    LabelButton(title: "Settings", image: "gearshape") { showSettings = true }
                    .popover(isPresented: $showSettings) {
                        VStack {
                            Section("Sort by") {
                                Picker("Sort", selection: $sortSelection) {
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
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView(directory: Folder())
            .environmentObject(TextAlert(title: ""))
            .environmentObject(MasterDirectory())
            .previewInterfaceOrientation(.landscapeRight)
    }
}
