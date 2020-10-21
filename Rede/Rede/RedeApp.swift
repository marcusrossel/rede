//
//  RedeApp.swift
//  Rede
//
//  Created by Marcus Rossel on 15.10.20.
//

import SwiftUI

@main
struct RedeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
