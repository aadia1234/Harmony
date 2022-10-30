//
//  SidebarView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/21/22.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var master: MasterDirectory
    @ObservedObject var newDirAlert: TextAlert

    @State private var selection = Set<Folder>()
    @State private var showFileNavView = false
    @State private var searchText = ""
    @State private var editMode: EditMode = .inactive
    
    private var isEditing: Bool { $editMode.wrappedValue == .active }
    
    private var results: [Folder] {
        get {
            if searchText.isEmpty {
                return Folder.parentFolders
            } else {
                return Folder.parentFolders.filter({$0.title.contains(searchText)})
            }
        }
        set {searchText = ""}
    }
    
    
    init(alert newDirAlert: TextAlert) {
        self.newDirAlert = newDirAlert
    }
    
    func menuButton(title: String) {
        newDirAlert.title = title
        newDirAlert.itemType = Folder.self
        $editMode.wrappedValue = .inactive
    }
    
    var body: some View {
        NavigationSplitView {
            List(results, id: \.self, children: \.subFolders, selection: $selection) { folder in
                ZStack {
                    NavigationLink(value: folder) {
                        Label(folder.title, systemImage: "folder")
                    }

                    .contextMenu {
                        if !isEditing {
                            Text("Last Accessed: \(folder.date, format: .dateTime.day().month().year())")
                            LabelButton(title: "Add new subfolder", image: "square.grid.3x1.folder.badge.plus") {
                                master.cd = folder
                                menuButton(title: "Add new sub folder")
                            }
                            
                            LabelButton(title: "Rename Folder", image: "character.cursor.ibeam") {
                                master.cd = folder
                                menuButton(title: "What would you like to rename \"\(folder.title)\" to?")
                            }
                            
                            LabelButton(title: "Move Folder", image: "rectangle.portrait.and.arrow.right") {
                                selection = [folder]
                                showFileNavView.toggle()
                            }
                            
                            LabelButton(title: "Delete Folder", image: "trash", role: .destructive) {
                                selection = [folder]
                                selection.forEach{$0.delete()}
                            }
                        }
                    }.id(folder.date)
                    
                }
            }
            .environment(\.editMode, $editMode)
            .onDisappear {
                editMode = .inactive
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Done" : "Edit") {
                        editMode = isEditing ? .inactive : .active
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    ZStack {
                        
                        if isEditing {
                            HStack {
                                LabelButton(title: "Move") { showFileNavView.toggle()
                                }
                                Spacer()
                                LabelButton(title: "Delete", role: .destructive) {
                                    selection.forEach{$0.delete()}
                                    $editMode.wrappedValue = .inactive
                                }
                            }
                            .disabled(selection.isEmpty)
                        } else {
                            LabelButton(title: "New Folder", image: "plus") {
                                newDirAlert.title = "Add new folder"
                                newDirAlert.itemType = Folder.self
                            }
                        }
                    }

                }
            }
            .animation(Animation.easeInOut(duration: 0), value: isEditing)
            .listStyle(.sidebar)
            .searchable(text: $searchText)
            .navigationTitle("Folders")
            .onChange(of: isEditing, perform: { newValue in
                print("edit mode changed")
            
            })
            
        } detail: {
            NavigationStack {
                DirectoryView(directory: selection.first ?? Folder.parentFolders.first ?? Folder())
                    .navigationDestination(for: Document.self) { doc in
                        if doc is Note {
                            NoteView(note: doc as! Note, thumbnail: Binding(
                                get: {
                                    (doc.thumbnailData ?? UIImage(systemName: (doc is WordPad) ? "doc.plaintext.fill" : "pencil")!.pngData())!
                            }, set: { Value in
                                doc.thumbnailData = Value
                            })
                         )
                        } else {
                            WordPadView(wordPad: doc as! WordPad)
                        }
                    }
            }
            
                
//                .navigationDestination(for: [Any].self, destination: { pair in
//                    let doc = pair[0]
//                    let thumbnail = pair[1]
//                    if doc is Note {
//                        NoteView(note: doc as! Note, thumbnail: thumbnail)
//                    } else {
//                        WordPadView(wordPad: doc as! WordPad)
//                    }
//                })
        }
        .sheet(isPresented: $showFileNavView) {FileNavigationView(items: $selection)}
//        .navigationDestination(isPresented: $newDirAlert.showNewItem) {
//            DirectoryView(directory: Folder.parentFolders.last ?? Folder())
//        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(alert: TextAlert(title: ""))
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(TextAlert(title: ""))
    }
}
