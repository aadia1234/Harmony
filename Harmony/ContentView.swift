//
//  ContentView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var newItemAlert = TextAlert(title: "New Item")
    @StateObject var newDirAlert = TextAlert(title: "New Parent Folder")
    @StateObject var master = MasterDirectory()
    
    private var alertShowing: Bool {
        return newItemAlert.visibility || newDirAlert.visibility
    }
    
    var body: some View {
        ZStack {
            VStack {
                NavigationView {
                    SidebarView(alert: newDirAlert)
                    DirectoryView(directory: Folder.parentFolders.first ?? Folder())
                        .opacity(Folder.allFolders.count > 0 ? 1 : 0)
                }
            }
            .disabled(alertShowing)
            .blur(radius: alertShowing ? 30 : 0)

            TextAlertView(alert: newItemAlert, itemType: Item.self) {
                if newItemAlert.itemType == Document.self {
                    master.doc.title = newItemAlert.text
                } else {
                    let doc: Document = newItemAlert.itemType.init() as! Document
                    doc.title = newItemAlert.text
                    doc.folder = master.cd
                }
            }

            TextAlertView(alert: newDirAlert, itemType: Folder.self) {
                let str = newDirAlert.title.lowercased()
                if str.contains("rename") {
                    master.cd.title = newDirAlert.text
                } else {
                    let parent: Folder? = newDirAlert.title.contains("sub") ? master.cd : nil
                    let folder = Folder(title: newDirAlert.text, parentFolder: parent, documents: [Document](), subFolders: nil)
                    parent?.subFolders?.append(folder)
                }
            }
        }
        .animation(.spring(), value: alertShowing)
        .edgesIgnoringSafeArea(.all)
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
