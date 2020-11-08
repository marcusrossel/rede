//
//  FolderDetail.swift
//  Rede
//
//  Created by Marcus Rossel on 30.08.20.
//

import SwiftUI

struct FolderDetail: View {

    init(folder: Binding<Folder>) {
        _model = StateObject(wrappedValue: Model(folder: folder))
    }
    
    @StateObject private var model: Model
    
    var body: some View {
        List {
            if !model.folder.bookmarks.unread.isEmpty {
                Section(header: Text("Unread")) {
                    ForEach(model.folder.bookmarks.unread.indexed()) { row in
                        BookmarkRow(bookmark: $model.folder.bookmarks.unread[row.index], folder: $model.folder)
                    }
                }
            }
            
            if model.settings.showReadBookmarks && !model.folder.bookmarks.read.isEmpty {
                Section(header: Text("Read")) {
                    ForEach(model.folder.bookmarks.read.indexed()) { row in
                        BookmarkRow(bookmark: $model.folder.bookmarks.read[row.index], folder: $model.folder)
                    }
                }
            }
        }
        .navigationTitle(model.folder.name)
        .listStyle(GroupedListStyle())
        .navigationBarItems(trailing: SortingPicker(sorting: $model.folder.sorting))
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
        @Binding var folder: Folder
        
        init(folder: Binding<Folder>) {
            _folder = folder
        }
    }
}

// MARK: Sorting Picker

extension FolderDetail {
    
    struct SortingPicker: View {
        
        @Binding var sorting: Folder.Sorting
        
        var body: some View {
            Picker(
                selection: $sorting,
                label: Text(Image(systemName: "arrow.up.arrow.down.circle.fill")),
                content: {
                    ForEach(Folder.Sorting.allCases) { sorting in
                        Label(sorting.rawValue, systemImage: sorting.iconName)
                            .tag(sorting)
                    }
                }
            )
            .pickerStyle(MenuPickerStyle())
        }
    }
}

// MARK: Previews

struct FolderDetail_Previews: PreviewProvider {
    
    static var previews: some View {
        StatefulPreview()
    }
    
    /// A `View` that is used for the preview, as `@State` doesn't work on non-`View`s.
    struct StatefulPreview: View {
        
        @State private var folder = Folder.previewData[1]
        
        var body: some View {
            FolderDetail(folder: $folder)
                .onAppear { Storage.shared.folders = Folder.previewData }
        }
    }
}

