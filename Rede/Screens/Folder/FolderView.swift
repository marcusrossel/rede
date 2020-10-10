//
//  FolderView.swift
//  Rede
//
//  Created by Marcus Rossel on 30.08.20.
//

import SwiftUI

struct FolderView: View {
    
    // MARK: State
    
    @AppStorage("showReadBookmarks", store: .rede)
    private var showReadBookmarks = true

    @Binding var folder: Folder
    
    private func binding(for bookmark: Bookmark) -> Binding<Bookmark> {
        guard let index = folder.bookmarks.firstIndex(of: bookmark) else {
            fatalError("Bookmark '\(bookmark.title)' is not in the folder '\(folder.name)'.")
        }
        
        return $folder.bookmarks[index]
    }
    
    // MARK: Body
    
    var body: some View {
        List {
            if !folder.unreadBookmarks.isEmpty {
                Section(header: Text("Unread")) {
                    ForEach(folder.unreadBookmarks) { bookmark in
                        BookmarkRow(bookmark: binding(for: bookmark), folder: $folder)
                    }
                }
            }
            
            if showReadBookmarks && !folder.readBookmarks.isEmpty {
                Section(header: Text("Read")) {
                    ForEach(folder.readBookmarks) { bookmark in
                        BookmarkRow(bookmark: binding(for: bookmark), folder: $folder)
                    }
                }
            }
        }
        .navigationTitle(folder.name)
        .listStyle(GroupedListStyle())
        .navigationBarItems(trailing:
            Picker(
                selection: $folder.sorting,
                label: Text(Image(systemName: "arrow.up.arrow.down.circle.fill")),
                content: {
                    ForEach(Folder.Sorting.allCases) { sorting in
                        Label(sorting.rawValue, systemImage: sorting.iconName)
                            .tag(sorting)
                    }
                }
            )
            .pickerStyle(MenuPickerStyle())
        )
    }
}

// MARK: - Previews

struct FolderView_Previews: PreviewProvider {
    
    static var previews: some View {
        StatefulPreview()
    }
    
    /// A `View` that is used for the preview, as `@State` doesn't work on non-`View`s.
    struct StatefulPreview: View {
        
        @State private var folder = Folder.previewData[1]
        
        var body: some View {
            FolderView(folder: $folder)
        }
    }
}

