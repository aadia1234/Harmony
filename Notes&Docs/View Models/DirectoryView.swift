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
    
    @ObservedObject var directory: Folder = Folder.parentFolders.first!
    
    @EnvironmentObject var newItemAlert: TextAlert
    @State private var searchText = ""
    @State private var selectedDocuments: [Document] = []

    init(directory: Folder) {
        self.directory = directory
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(searchResults, id: \.self.id) { doc in
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
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button {
                    selectedDocuments.forEach({$0.delete()})
                } label: {
                    Text("Delete")
                }
                .opacity(editMode?.wrappedValue == .active ? 1 : 0)
                .tint(.red)
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Group {
                    EditButton()
                    ZStack {
                        HStack {
                            // newItemAlert.showNewItem
                            NavigationLink(isActive: .constant(false)) {
                                if newItemAlert.item is Note {
                                    NoteView(note: newItemAlert.item as! Note)
                                } else if newItemAlert.item is WordPad {
                                    WordPadView(wordPad: newItemAlert.item as! WordPad)
                                }
                            } label: {
                                EmptyView()
                            }
                            .disabled(true)
                            
                            Menu {
                                Button {
                                    newItemAlert.item = Folder()
                                    newItemAlert.item.title = ""
                                    newItemAlert.visibility = true
                                } label: {
                                    Label("New Folder", systemImage: "folder.badge.plus")
                                }
                                
                            
                                Button {
                                    newItemAlert.item = Note()
                                    newItemAlert.visibility = true
                                } label: {
                                    Label("New Note", systemImage: "note.text.badge.plus")
                                }
                                
                                Button {
                                    newItemAlert.item = WordPad()
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
