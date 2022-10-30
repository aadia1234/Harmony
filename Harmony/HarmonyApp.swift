 //
//  HarmonyApp.swift
//  Harmony
//
//  Created by Aadi Anand on 10/24/22.
//

import SwiftUI

@main
struct HarmonyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
