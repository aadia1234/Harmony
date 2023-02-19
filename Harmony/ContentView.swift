//
//  ContentView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI

struct FolderNavigationView: View {
    @EnvironmentObject var updateView: UpdateView
    
    var body: some View {
        NavigationStack {
            DirectoryView(directory: updateView.sidebarSelection.first ?? Folder.parentFolders.first ?? Folder())
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
    }
}

struct SplitView: UIViewControllerRepresentable {
    @EnvironmentObject var updateView: UpdateView
    let storyboard = UIStoryboard(name: "SplitViewController", bundle: Bundle.main)

    
    func makeUIViewController(context: Context) -> SplitViewController {
        let controller = SplitViewController(style: .doubleColumn)
        return controller
    }
    
    func updateUIViewController(_ vc: SplitViewController, context: Context) {
        DataController.container.loadPersistentStores { description, error in
            if (error != nil) { print(error?.localizedDescription) }
        }
        vc.preferredDisplayMode = updateView.enableSidebar ? .oneBesideSecondary : .secondaryOnly
        vc.presentsWithGesture = updateView.enableSidebar
        vc.displayModeButtonVisibility = updateView.enableSidebar ? .always : .never
        
        let sidebarController = storyboard.instantiateViewController(identifier: "CollectionSidebarView") { coder in CollectionViewController(updateView, coder: coder) }
        let folderController = storyboard.instantiateViewController(identifier: "FolderViewController") { coder in FolderViewController(updateView, coder: coder) }
        
//        controller.viewControllers = [
//            UINavigationController(rootViewController: sidebarController),
//            UINavigationController(rootViewController: folderController)
//        ]
        vc.viewControllers = [
            UINavigationController(rootViewController: sidebarController),
            UINavigationController(rootViewController: folderController)
        ]
        
//        let sidebarController = vc.viewController(for: .primary)!
//        let sidebarView = UIHostingController(rootView: updateView.sidebar)
//        sidebarController.addChild(sidebarView)
////        sidebarView.view.translatesAutoresizingMaskIntoConstraints = false
//        sidebarView.view.frame = sidebarController.view.bounds
//        sidebarController.view.addSubview(sidebarView.view)
        
//        let detailController = vc.viewController(for: .primary)!
//        let detailView = UIHostingController(rootView: updateView.folderNavigationView)
////        detailView.view.translatesAutoresizingMaskIntoConstraints = false
//        detailController.addChild(detailView)
//        detailView.view.frame = detailController.view.bounds
//        detailController.view.addSubview(detailView.view)
        
    }
}

struct ContentView: View {
    @StateObject var newItemAlert = TextAlert(title: "New Item")
    @StateObject var newDirAlert = TextAlert(title: "New Parent Folder")
    @StateObject var master = MasterDirectory()
    @EnvironmentObject var updateView: UpdateView
    
    @State private var editMode: EditMode = .inactive

    private var alertShowing: Bool {
        return newItemAlert.visibility || newDirAlert.visibility
    }
    
    var body: some View {
        
        ZStack {
            NavigationSplitView {
                updateView.sidebar
            } detail: {
                updateView.folderNavigationView
            }
            .sheet(isPresented: $updateView.showFileNavView) {FileNavigationView(items: $updateView.sidebarSelection)}
            .edgesIgnoringSafeArea(.all)
            .environmentObject(updateView)
            .disabled(alertShowing)
            .blur(radius: alertShowing ? 30 : 0)
            .environment(\.editMode, $editMode)


            TextAlertView(alert: newItemAlert, itemType: Item.self) {
                if newItemAlert.itemType == Document.self {
                    master.doc.title = newItemAlert.text
                } else {
                    let doc: Document = newItemAlert.itemType.init() as! Document
                    doc.title = newItemAlert.text
                    doc.folder = master.cd
                    doc.date = Date.now
                    
                    if newItemAlert.itemType == WordPad.self {
                        (doc as! WordPad).addToStoredPages(Page(text: "New Page", index: 0))
                    }
                }
            }

            TextAlertView(alert: newDirAlert, itemType: Folder.self) {
                if newDirAlert.title.lowercased().contains("rename") {
                    master.cd.title = newDirAlert.text
                } else {
                    let parent: Folder? = newDirAlert.title.contains("sub") ? master.cd : nil
                    let folder = Folder(title: newDirAlert.text, parentFolder: parent, documents: [Document](), subFolders: nil)
                    parent?.subFolders?.append(folder)
                }
            }
        }
        .navigationViewStyle(.automatic)
        .onAppear {
            updateView.sidebar = SidebarView(alert: newDirAlert)
            updateView.folderNavigationView = FolderNavigationView()
        }
        .edgesIgnoringSafeArea(.all)
        .animation(.default, value: alertShowing)
        .environmentObject(newItemAlert)
        .environmentObject(master)
//        .persistentSystemOverlays(.hidden)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
