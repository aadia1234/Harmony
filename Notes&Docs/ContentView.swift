//
//  ContentView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI

class UpdateView: ObservableObject {
    @Published var didUpdate = false
    
    func update() {
        didUpdate.toggle()
        didUpdate.toggle()
    }
}

struct ContentView: View {
    @StateObject var newItemAlert = TextAlert(title: "New Item")
    @StateObject var newDirAlert = TextAlert(title: "New Parent Folder")
    @StateObject var master = MasterDirectory()
    @State var dirView = DirectoryView(directory: Folder.parentFolders.first!)
    @State var sideBarView = SidebarView(alert: TextAlert(title: ""))
    @State private var editMode = EditMode.inactive
    @State private var showRecents = true
    
    private var alertShowing: Bool {
        return newItemAlert.visibility || newDirAlert.visibility
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: 1.0)
                NavigationView {
                    SidebarView(alert: newDirAlert)
                    DirectoryView(directory: Folder.parentFolders.first ?? Folder())
                        .opacity(Folder.allFolders.count > 0 ? 1 : 0)
                }
            }
            .disabled(alertShowing)
            .blur(radius: alertShowing ? 30 : 0)
            
            TextAlertView(alert: newItemAlert, text: $newItemAlert.item.title) {
                newItemAlert.visibility = false
                newItemAlert.showNewItem = false

            } successHandler: {
                if newItemAlert.item is Folder {
                    if master.cd.subFolders == nil { master.cd.subFolders = [] }
                    master.cd.subFolders?.append(newItemAlert.item as! Folder)
                } else {
                    master.cd.documents.append(newItemAlert.item as! Document)
                }
                newItemAlert.visibility = false
                newItemAlert.showNewItem = true
            }
            .disabled(!alertShowing || newDirAlert.visibility)

            
            TextAlertView(alert: newDirAlert, text: $newDirAlert.item.title) {
                newDirAlert.visibility = false
                newDirAlert.showNewItem = false
 
            } successHandler: {
                Folder.parentFolders.append(newDirAlert.item as! Folder)
                newDirAlert.visibility = false
                newDirAlert.showNewItem = true
            }
            .disabled(!alertShowing || newItemAlert.visibility)
            
        }
        .onAppear {
            sideBarView = SidebarView(alert: newDirAlert)
        }
        .animation(.spring(), value: alertShowing)
        .environmentObject(UpdateView())
        .environmentObject(newItemAlert)
        .environmentObject(master)
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
