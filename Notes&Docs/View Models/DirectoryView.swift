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
    
    @ObservedObject var directory: Directory = Directory.allDirectories.first!
    
    @EnvironmentObject var newItemAlert: TextAlert
    @State private var searchText = ""

    init(directory: Directory) {
        self.directory = directory
    }
    
    var body: some View {
        VStack {
            ScrollView {
                if searchResults.contains(where: {$0 is Folder}) {
                    Group {
                        Text("Folders")
                            .font(.title2)
                        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                            ForEach(searchResults.filter({$0 is Folder}), id: \.self.id) { folder in
                                FileView(item: folder)
                            }
                        }
                    }
                    .padding(.top, 50)
                }
                
                if searchResults.contains(where: {$0 is Document}) {
                    Group {
                        Text("Documents")
                            .font(.title2)
                        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                            ForEach(searchResults.filter({$0 is Document}), id: \.self.id) { doc in
                                FileView(item: doc)
                            }
                        }
                    }
                    .padding(.top, 50)
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
        .navigationTitle(directory.title)
        .opacity(updateView.didUpdate ? 0 : 1)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Group {
                    EditButton()
                    ZStack {
                        HStack {
                            // newItemAlert.showNewItem
                            NavigationLink(isActive: .constant(false)) {
                                if newItemAlert.item is Folder {
                                    DirectoryView(directory: newItemAlert.item as! Folder)
                                } else if newItemAlert.item is Note {
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
                    .disabled(Directory.allDirectories.isEmpty || editMode!.wrappedValue.isEditing)
                }
            }
        }
    }
    
    var searchResults: [Item] {
        if searchText.isEmpty {
            return directory.items
        } else {
            return directory.items.filter({ $0.title.contains(searchText) })
        }
    }
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView(directory: Directory())
            .environmentObject(UpdateView())
            .environmentObject(TextAlert(title: ""))
            .environmentObject(MasterDirectory())
            .previewInterfaceOrientation(.landscapeRight)
    }
}
