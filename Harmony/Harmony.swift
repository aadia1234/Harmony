//
//  Notes_DocsApp.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI
import CoreData
import PSPDFKit
import PSPDFKitUI


@main
struct Harmony: App {
    @StateObject var updateView = UpdateView()
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let controller = DataController.shared
    
    init() {
        // Set your license key here. PSPDFKit is commercial software.
        // Each PSPDFKit license is bound to a specific app bundle id.
        // Visit https://customers.pspdfkit.com to get your demo or commercial license key.
        SDK.setLicenseKey("wMxS7DFOAlVAK-LYI1u-8Z5xX6IKWNkyJ-2eWnmT9zHj7NnMHTHuPmxgkPky9H7VVES3BTuah0Cuukfq7wNoFxMP9UWjlzKTBB6g56A3q_uFceV-hSWhe1jhD6N7UqObofRt1C-d9vDPwQMhCixTJBtY0WgldPe74PVCvu84Upm6haNDXenI1s1cjUftuEBQYOJNL0T6qZ27bRTtuuJfEY2QasLzSA8gYycvj7bqg2o5t0ENPodCcrA0BRiYeoh8MwfbKU3XZq2JQczC8R0SPJZhNjlnWyIvPU5XMKgq2kuFufd7wISCj6lKghHD8BbShVp2QtgL9YxirHOTQhXoKx5FVEr9O1z6Lyo-xNz5iyMaG5sx-xRlm82q6FVI4jZd1JdtmrLzuJaagI-Id_0pP0cLRaMrra5j_C46VBfynNogD-6IG0essznlpPnWp_YnN-g1P3jIwKkg4-kx_8U6mTwXsQiWRcBr7KIR6Q8XWLS7F_xZlz55diiMQP57KcbnoF7-cFAaejJF4l7MghIGsMRVRF-UUj5_Yt4Kp9o-2jsFG6v_eh-UApUCZyZK-dinUHxCOXOmq8yOARsUj1hSIJfGvBdIO4YteZ6lkLHCZ0fZnHssSsLgaBFMWVwMIYZS")
    }
    
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

