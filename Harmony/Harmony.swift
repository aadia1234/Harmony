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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(updateView)
//                .environment(\.managedObjectContext, controller.container.viewContext)
                .onChange(of: scenePhase) { _ in controller.save() }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
            
    static var orientationLock = UIInterfaceOrientationMask.portrait {
        didSet {
            if #available(iOS 16.0, *) {
                UIApplication.shared.connectedScenes.forEach { scene in
                    if let windowScene = scene as? UIWindowScene {
                        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientationLock))
                    }
                }
                
                UIViewController.attemptRotationToDeviceOrientation()
            } else {
                if orientationLock == .portrait {
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                } else {
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                }
            }
        }
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

