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
    @StateObject var renameDocAlert = TextAlert(title: "Rename Document")
    @StateObject var master = MasterDirectory()
    
    private var alertShowing: Bool {
        return newItemAlert.visibility || newDirAlert.visibility || renameDocAlert.visibility
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

            TextAlertView(alert: newItemAlert, itemType: Item.self) {
                if newItemAlert.itemType == Folder.self {
                    if master.cd.subFolders == nil { master.cd.subFolders = [] }
                    _ = Folder(title: newItemAlert.text, parentFolder: master.cd, documents: [Document](), subFolders: nil)
                } else {
                    let doc: Document = newItemAlert.itemType.init() as! Document
                    doc.title = newItemAlert.text
                    doc.folder = master.cd
                }
            }


            TextAlertView(alert: newDirAlert, itemType: Folder.self) {
                _ = Folder(title: newDirAlert.text, parentFolder: nil, documents: [Document](), subFolders: nil)
            }
            
//            TextAlertView(alert: renameDocAlert, itemType: Document.self) {}

        }
        .animation(.spring(), value: alertShowing)
        .edgesIgnoringSafeArea(.all)
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
