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
    @ObservedObject var newDirAlert: TextAlert
    @State private var searchText = ""
    
    init(alert newDirAlert: TextAlert) {
        self.newDirAlert = newDirAlert
        UITableView.appearance().backgroundColor = UIColor.systemGray6
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach(searchResults, id: \.self.id) { dir in
                    NavigationLink(dir.title, destination: DirectoryView(directory: dir))
                }
                .onDelete(perform: { offsets in
                    Directory.allDirectories.remove(atOffsets: offsets)
                    updateView.update()
                })
                .onMove(perform: { source, destination in
                    Directory.allDirectories.move(fromOffsets: source, toOffset: destination)
                    updateView.update()
                })
                
            }
            .searchable(text: $searchText)
            .opacity(updateView.didUpdate ? 0 : 1)
            .navigationTitle("Directories")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    EditButton()
                }
                ToolbarItem(placement: .bottomBar) {
                    ZStack {
                        NavigationLink(isActive: $newDirAlert.showNewItem) {
                            DirectoryView(directory: Directory.allDirectories.last ?? Directory())
                        } label: {
                            EmptyView()
                        }

                        Button {
                            newDirAlert.item = Directory()
                            newDirAlert.item.title = ""
                            newDirAlert.visibility = true
                            newDirAlert.showNewItem = false
                        } label: {
                            Image(systemName: "plus")
                        }
                        .disabled(editMode!.wrappedValue.isEditing)

                    }
                }
            }
        }
    }
    
    var searchResults: [Directory] {
        if searchText.isEmpty {
            return Directory.allDirectories
        } else {
            return Directory.allDirectories.filter({ $0.title.contains(searchText) })
        }
        
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(alert: TextAlert(title: "Title"))
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(TextAlert(title: ""))
            .environmentObject(UpdateView())
    }
}
