//
//  Notes_DocsApp.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI


@main
struct Notes_DocsApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
                }
        }
    }
}
