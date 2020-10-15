//
//  Home.swift
//  Rede
//
//  Created by Marcus Rossel on 29.08.20.
//

import SwiftUI
import Combine

struct Home: View {
    
    @EnvironmentObject var shelf: Shelf
    
    var body: some View {
        List {
            Section {
                Folders(folders: $shelf.folders)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Folders")
        .navigationBarItems(trailing:
            NavigationLink(destination:
                SettingsView()/*SwiftUI bug*/.environmentObject(shelf)
            ) {
                Image(systemName: "gear")
            }
        )
    }
}

// MARK: - Previews

struct Home_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            Home()
                .environmentObject(Shelf.previewData)
        }
    }
}
