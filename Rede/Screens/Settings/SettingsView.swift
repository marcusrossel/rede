//
//  SettingsView.swift
//  Rede
//
//  Created by Marcus Rossel on 29.08.20.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var settings = Settings()
    /*SwiftUI bug*/ @EnvironmentObject private var shelf: Shelf
    
    var body: some View {
        Form {
            Section(header: Text("Setup")) {
                NavigationLink(destination: FoldersEditor()/*SwiftUI bug*/.environmentObject(shelf)) {
                    Label(
                        title: "Folders",
                        icon: (name: "folder.fill", color: Color(.systemBlue))
                    )
                }
            }
            
            Section(header: Text("Appearance")) {
                Toggle(isOn: $settings.showReadBookmarks) {
                    Label(
                        title: "Show Read Bookmarks",
                        icon: (name: "rectangle.fill.on.rectangle.angled.fill", color: Color(.systemOrange))
                    )
                }
                
                Picker(
                    selection: $settings.language,
                    label: Label(
                        title: "Language",
                        icon: (name: "globe", color: Color(.systemOrange))
                    ),
                    content: {
                        ForEach(Language.allCases) { language in
                            Text(language.rawValue).tag(language)
                        }
                    }
                )
                .pickerStyle(DefaultPickerStyle())
            }
            
            Section(header: Text("Behavior")) {
                Toggle(isOn: $settings.automaticallyNameBookmarks) {
                    Label(
                        title: "Automatically Name Bookmarks",
                        icon: (name: "textbox", color: Color(.systemPink))
                    )
                }
 
                Toggle(isOn: $settings.automaticallyMarkAsRead) {
                    Label(
                        title: "Automatically Mark Bookmarks As Read",
                        icon: (name: "bookmark.fill", color: Color(.systemPink))
                    )
                }
            }
            
            Section(header: Text("Data")) {
                Label(
                    title: "Export Bookmarks",
                    icon: (name: "tray.and.arrow.up.fill", color: Color(.systemGray))
                )
            }
        }
        .navigationTitle("Settings")
    }
}

// MARK: - Previews

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
