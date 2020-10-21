//
//  FolderDetail.swift
//  Rede
//
//  Created by Marcus Rossel on 30.08.20.
//

import SwiftUI

struct FolderDetail: View {
    
    @StateObject private var storage = Storage.shared

    @Binding var folder: Folder
    
    private func binding(for bookmark: Bookmark) -> Binding<Bookmark> {
        if let index = folder.bookmarks.read.firstIndex(of: bookmark) {
            return $folder.bookmarks.read[index]
        } else if let index = folder.bookmarks.unread.firstIndex(of: bookmark) {
            return $folder.bookmarks.unread[index]
        } else {
            fatalError("Bookmark '\(bookmark.title)' is not in the folder '\(folder.name)'.")
        }
    }
    
    var body: some View {
        List {
            if !folder.bookmarks.unread.isEmpty {
                Section(header: Text("Unread")) {
                    ForEach(folder.bookmarks.unread) { bookmark in
                        BookmarkRow(bookmark: binding(for: bookmark), folder: $folder)
                    }
                }
            }
            
            if storage.settings.showReadBookmarks && !folder.bookmarks.read.isEmpty {
                Section(header: Text("Read")) {
                    ForEach(folder.bookmarks.read) { bookmark in
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

// MARK: Destinations

extension FolderDetail {
    
    fileprivate enum Destination {

    }
}

// MARK: View Model

extension FolderDetail {
    
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

struct FolderView_Previews: PreviewProvider {
    
    static var previews: some View {
        StatefulPreview()
    }
    
    /// A `View` that is used for the preview, as `@State` doesn't work on non-`View`s.
    struct StatefulPreview: View {
        
        @State private var folder = Folder.previewData[1]
        
        var body: some View {
            FolderView(folder: $folder)
                .onAppear { Storage.shared.folders = Folder.previewData }
        }
    }
}

