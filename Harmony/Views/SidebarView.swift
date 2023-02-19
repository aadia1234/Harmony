//
//  SidebarView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/21/22.
//

import SwiftUI

struct MyDisclosureStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Button {
                withAnimation {
                    configuration.isExpanded.toggle()
                }
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    configuration.label
                    Spacer()
                    Text(configuration.isExpanded ? "hide" : "show")
                        .foregroundColor(.accentColor)
                        .font(.caption.lowercaseSmallCaps())
                        .animation(nil, value: configuration.isExpanded)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            if configuration.isExpanded {
                configuration.content
            }
        }
    }
}


struct SidebarView: View {
    @EnvironmentObject var master: MasterDirectory
    @ObservedObject var newDirAlert: TextAlert
    @EnvironmentObject var updateView: UpdateView

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
        List(results, id: \.self, children: \.subFolders, selection: $updateView.sidebarSelection) { folder in
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
                            updateView.sidebarSelection = [folder]
                            updateView.showFileNavView.toggle()
                        }
                        
                        LabelButton(title: "Delete Folder", image: "trash", role: .destructive) {
                            updateView.sidebarSelection = [folder]
                            updateView.sidebarSelection.forEach{$0.delete()}
                        }
                    }
                }.id(folder.date)
            }
        }
        .listStyle(SidebarListStyle())
        .environment(\.editMode, $editMode)
        .onDisappear { editMode = .inactive }
//        .toolbar(updateView.enableSidebar ? .visible : .hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                LabelButton(title: (isEditing ? "Done" : "Edit")) {
                    editMode = isEditing ? .inactive : .active
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                ZStack {
                    if isEditing {
                        HStack {
                            LabelButton(title: "Move") { updateView.showFileNavView.toggle() }
                            Spacer()
                            LabelButton(title: "Delete", role: .destructive) {
                                updateView.sidebarSelection.forEach{$0.delete()}
                                $editMode.wrappedValue = .inactive
                            }
                        }
                        .disabled(updateView.sidebarSelection.isEmpty)
                    } else {
                        LabelButton(title: "New Folder", image: "plus") {
                            newDirAlert.title = "Add new folder"
                            newDirAlert.itemType = Folder.self
                        }
                    }
                    
                }

            }
        }
        .animation(Animation.easeInOut(duration: 0.5), value: isEditing)
        .searchable(text: $searchText)
        .navigationTitle("Folders")
        .toolbarRole(.editor)
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
