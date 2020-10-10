//
//  RedeApp.swift
//  Rede
//
//  Created by Marcus Rossel on 29.08.20.
//

import SwiftUI

// MARK: - App

@main
struct RedeApp: App {

    #if DEBUG
    private let shelf = Shelf.previewData
    #else
    private let shelf = Shelf()
    #endif
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Home()
                    .environmentObject(shelf)
            }
        }
    }
}
