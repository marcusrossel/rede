//
//  RedeApp.swift
//  Rede / App
//
//  Created by Marcus Rossel on 08.11.20.
//

import SwiftUI

@main
struct RedeApp: App {
    
    @StateObject private var storage: Storage = .shared
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Home()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:     storage.load()
            case .background: try? storage.save()
            default:          break
            }
        }
    }
}
