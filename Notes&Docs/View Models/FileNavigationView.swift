//
//  FileNavigationView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/10/22.
//

import SwiftUI

struct FileNavigationView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText = ""
    @State private var selectedFolder: Folder = Folder()
    @State var folders: Set<Folder>
    
    var body: some View {
        NavigationView {
            VStack {
                List(searchResults, id: \.self, children: \.subFolders) { folder in
                    Button {
                        selectedFolder = folder
                    } label: {
                        HStack {
                            Label(folder.title, systemImage: "folder")
                                Spacer()
                            Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                                    .opacity(selectedFolder == folder ? 1 : 0)
                        }
                    }
                    .disabled(folders.contains(where: {folder.hasAncestor($0) || $0 == folder || $0.getParent() == folder}))
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                
                Spacer(minLength: 10)
                
                Button {
                    folders.forEach({$0.moveToParentFolders()})
                    dismiss()
                } label: {
                    Text("Move selected folder\(folders.count > 1 ? "s": "") to parent folders")
                        .font(.headline)
                        .fontWeight(.semibold)
                        
                }
                .padding(20)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .clipShape(Capsule())
                .disabled(folders.contains(where: {Folder.parentFolders.contains($0)}))
                
                Spacer(minLength: 10)
            }
            .navigationTitle("Select a Folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        folders.forEach({$0.move(to: selectedFolder)})
                        dismiss()
                    } label: {
                        Text("Move")
                    }
                    .disabled(!Folder.allFolders.contains(selectedFolder))
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var searchResults: [Folder] {
        if searchText.isEmpty {
            return Folder.parentFolders
        } else {
            return Folder.allFolders.filter({ $0.title.contains(searchText) })
        }
        
    }
}

struct FileNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        FileNavigationView(folders: [])
            .previewInterfaceOrientation(.landscapeRight)
    }
}
