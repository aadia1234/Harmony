//
//  Notes_DocsApp.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI
import CoreData

@main
struct Harmony: App {
    @StateObject var updateView = UpdateView()
    @Environment(\.scenePhase) var scenePhase
    let controller = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(updateView)
                .environment(\.managedObjectContext, controller.container.viewContext)
                .onChange(of: scenePhase) { _ in controller.save() }
        }
    }
}


