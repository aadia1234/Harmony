//
//  DirectoryView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/21/22.
//

import SwiftUI

struct DirectoryView: View {
    @EnvironmentObject var updateView: UpdateView
    @EnvironmentObject var master: MasterDirectory
    @Environment(\.editMode) var editMode
    
    @ObservedObject var directory: Folder = Folder.parentFolders.first ?? Folder()
    @EnvironmentObject var newItemAlert: TextAlert
    @State private var searchText = ""
    @State private var selectedDocuments = Set<Document>()
    @State private var showFileNavView = false
    
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
                    Button {
                        showFileNavView.toggle()
                    } label: {
                        Text("Move")
                    }
                    .opacity(editMode?.wrappedValue == .active ? 1 : 0)
                    
                    Spacer()
                    
                    Button {
                        selectedDocuments.forEach({$0.delete()})
                    } label: {
                        Text("Delete")
                    }
                    .opacity(editMode?.wrappedValue == .active ? 1 : 0)
                    .tint(.red)
                }
                
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Group {
                    EditButton()
                    ZStack {
                        HStack {
                            // newItemAlert.showNewItem
                            NavigationLink(isActive: .constant(false)) {
//                                if newItemAlert.itemType == Note.self {
//                                    NoteView(note: newItemAlert.item as! Note)
//                                } else if newItemAlert.itemType == WordPad.self {
//                                    WordPadView(wordPad: newItemAlert.item as! WordPad)
//                                }
                            } label: {
                                EmptyView()
                            }
                            .disabled(true)
                            
                            Menu {
                                Button {
                                    newItemAlert.itemType = Folder.self
                                    newItemAlert.text = ""
                                    newItemAlert.visibility = true
                                } label: {
                                    Label("New Folder", systemImage: "folder.badge.plus")
                                }
                                
                            
                                Button {
                                    newItemAlert.itemType = Note.self
                                    newItemAlert.visibility = true
                                } label: {
                                    Label("New Note", systemImage: "note.text.badge.plus")
                                }
                                
                                Button {
                                    newItemAlert.itemType = WordPad.self
                                    newItemAlert.visibility = true
                                } label: {
                                    Label("New WordPad", systemImage: "doc.badge.plus")
                                }
                                
                            } label: {
                                Image(systemName: "plus")
                            }
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "gearshape")
                            }
                        }
                        .onTapGesture {
                            master.cd = directory
                        }
                    }
                    .disabled(Folder.parentFolders.isEmpty || editMode!.wrappedValue.isEditing)
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
