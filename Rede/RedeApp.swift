//
//  RedeApp.swift
//  Rede
//
//  Created by Marcus Rossel on 08.11.20.
//

import SwiftUI

// MARK: App

@main
struct RedeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Home()
            }
        }
    }
}

// MARK: App Delegate

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    private let storage: Storage = .shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #warning("TEST DATA")
        storage.folders = Folder.previewData
        
        return true
    }
}
