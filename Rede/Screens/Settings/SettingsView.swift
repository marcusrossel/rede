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
                        title: { Text("Folders") },
                        icon: {
                            Image(systemName: "folder.fill")
                                .foregroundColor(Color(.systemBlue))
                        }
                    )
                }
            }
            
            Section(header: Text("Appearance")) {
                Toggle(isOn: $settings.showReadBookmarks) {
                    Label(
                        title: { Text("Show Read Bookmarks") },
                        icon: {
                            Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
                                .foregroundColor(Color(.systemOrange))
                        }
                    )
                }
                
                Picker(
                    selection: $settings.language,
                    label: Label(title: { Text("Language") }, icon: {
                                Image(systemName: "globe")
                                    .foregroundColor(Color(.systemOrange))
                            }),
                    content: {
                        ForEach(Language.allCases) { language in
                            Text(language.rawValue).tag(language)
                        }
                    }
                )
                .pickerStyle(DefaultPickerStyle())
            }
            
            Section(header: Text("Data")) {
                Toggle(isOn: $settings.automaticallyNameBookmarks) {
                    Label(
                        title: { Text("Automatically Name Bookmarks") },
                        icon: {
                            Image(systemName: "pencil.and.ellipsis.rectangle")
                                .foregroundColor(Color(.systemPink))
                        }
                    )
                }
 
                Label(
                    title: { Text("Export Bookmarks") },
                    icon: {
                        Image(systemName: "tray.and.arrow.up.fill")
                            .foregroundColor(Color(.systemPink))
                    }
                )
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
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
