//
//  Home.swift
//  Rede
//
//  Created by Marcus Rossel on 29.08.20.
//

import SwiftUI
import LazyViewSwiftUI

// MARK: Home

struct Home: View {
    
    @StateObject private var model = Model()
    
    var body: some View {
        List {
            ForEach(model.folders.indexed()) { let (index, folder) = $0.destructured
                NavigationLink(destination: Destination.folder($model.folders[index])) {
                    HStack {
                        Label(title: folder.name, icon: folder.icon)
                        Spacer()
                        Text("\(folder.bookmarks.unread.count)")
                            .font(.callout)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Folders")
        .navigationBarItems(trailing:
            NavigationLink(destination: Destination.settings) {
                Image(systemName: "gear")
            }
        )
    }
}

// MARK: Destinations

extension Home {
    
    fileprivate enum Destination {
        
        static var settings: some View { LazyView(SettingsView()) }
        
        static func folder(_ binding: Binding<Folder>) -> some View {
            LazyView(FolderDetail(folder: binding))
        }
    }
}

// MARK: View Model

extension Home {
    
    @dynamicMemberLookup
    fileprivate final class Model: ObservableObject {

        subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<Storage, T>) -> T {
            get { storage[keyPath: keyPath] }
            set { storage[keyPath: keyPath] = newValue }
        }
        
        @Published private var storage = Storage.shared
    }
}

// MARK: Previews

struct Home_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            Home()
                .onAppear { Storage.shared.folders = Folder.previewData }
        }
    }
}
