//
//  ShareExtension.Sheet.swift
//  Rede / Share Extension
//
//  Created by Marcus Rossel on 11.11.20.
//

import SwiftUI

extension ShareExtension {
    
    struct Sheet: View {
        
        @StateObject private var storage: Storage = .shared
        @ObservedObject var model: Model
        
        @State private var destination: Folder.ID?
        
        private var title: Binding<String> {
            Binding { model.websiteTitle ?? "" } set: { model.websiteTitle = $0 }
        }
        
        private var url: Binding<URL> {
            Binding {
                model.url ?? URL(string: "https://your.url")!
            } set: {
                model.url = $0
            }
        }
        
        private var saveIsDisabled: Bool {
            guard let title = model.websiteTitle else { return true }
            return destination == nil || model.url == nil || title.isEmpty
        }
        
        var body: some View {
            NavigationView {
                VStack {
                    TextField("Bookmark Title", text: title)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .padding([.leading, .trailing, .top])
                        .padding(.top, 8)
                    
                    #warning("This isn't working out.")
                    BookmarkEditor.URLField(url: url)
                        .font(.footnote)
                        .padding([.leading, .trailing], 32)
                        .padding(.bottom, 27)
                    
                    Divider()
                    
                    HStack {
                        Spacer()
                        BookmarkEditor.FavoriteButton(isFavorite: $model.isFavorite)
                        Spacer()
                        BookmarkEditor.ReadButton(readDate: $model.readDate)
                        Spacer()
                        NewFolderButton(folders: $storage.folders, destination: $destination)
                        Spacer()
                    }
                    .padding(.top, 8)
                    
                    Divider()
                    
                    FolderPicker(title: "Destination", selection: $destination)
                        .padding([.top], 20)
                }
                .navigationBarTitle("New Bookmark", displayMode: .large)
                .navigationBarItems(
                    leading:
                        Button("Cancel", action: model.dismissShareExtension),
                    trailing:
                        Button("Save") {
                            let bookmark = Bookmark(
                                title: model.websiteTitle!,
                                url: model.url!,
                                readDate: model.readDate,
                                isFavorite: model.isFavorite,
                                folderID: destination!
                            )
                            storage.folders[volatile: destination!]?.bookmarks.insert(bookmark, at: 0)
                            try? storage.save()
                            model.dismissShareExtension()
                        }
                        .disabled(saveIsDisabled)
                )
            }
        }
    }
}
