//
//  SettingsView.swift
//  Rede
//
//  Created by Marcus Rossel on 29.08.20.
//

import SwiftUI
import LazyViewSwiftUI

struct SettingsView: View {
    
    @StateObject private var storage = Storage.shared
    
    var body: some View {
        Form {
            Section(header: Text("Setup")) {
                NavigationLink(destination: LazyView(FoldersEditor())) {
                    Label(title: "Folders", icon: Icon(name: "folder.fill", uiColor: .systemBlue))
                }
            }
            
            Section(header: Text("Appearance")) {
                Toggle(isOn: $storage.settings.showReadBookmarks) {
                    Label(
                        title: "Show Read Bookmarks",
                        icon: Icon(name: "rectangle.fill.on.rectangle.angled.fill", uiColor: .systemOrange)
                    )
                }
                
                Picker(
                    selection: $storage.settings.language,
                    label: Label(
                        title: "Language",
                        icon: Icon(name: "globe", uiColor: .systemOrange)
                    ),
                    content: {
                        ForEach(Settings.Language.allCases) { language in
                            Text(language.rawValue).tag(language)
                        }
                    }
                )
                .pickerStyle(DefaultPickerStyle())
            }
            
            Section(header: Text("Behavior")) {
                Toggle(isOn: $storage.settings.automaticallyNameBookmarks) {
                    Label(
                        title: "Automatically Name Bookmarks",
                        icon: Icon(name: "textbox", uiColor: .systemPink)
                    )
                }
 
                Toggle(isOn: $storage.settings.automaticallyMarkAsRead) {
                    Label(
                        title: "Automatically Mark Bookmarks As Read",
                        icon: Icon(name: "bookmark.fill", uiColor: .systemPink)
                    )
                }
            }
            
            Section(header: Text("Data")) {
                Label(
                    title: "Export Bookmarks",
                    icon: Icon(name: "tray.and.arrow.up.fill", uiColor: .systemGray)
                )
            }
        }
        .navigationTitle("Settings")
    }
}

// MARK: Previews

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            SettingsView()
                .onAppear { Storage.shared.folders = Folder.previewData }
        }
    }
}
