//
//  App.swift
//  Rede
//
//  Created by Marcus Rossel on 15.10.20.
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
    
    private let storage = Storage.shared
    
    #warning("TEST")
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        if storage.folders.isEmpty { storage.folders = Folder.previewData }
        return true
    }
    
    func applicationDidEnterBackground(_ app: UIApplication) {
        try? storage.save()
    }
}
