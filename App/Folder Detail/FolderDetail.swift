//
//  FolderDetail.swift
//  Rede / App
//
//  Created by Marcus Rossel on 08.11.20.
//

import SwiftUI

struct FolderDetail: View {
    
    @StateObject private var storage: Storage = .shared
    @Binding var folder: Folder
    
    // Setting the edit mode from a subview, does not currently set it in the parent. This is a
    // workaround.
    @State private var editMode: EditMode? = .inactive
    @State private var sheet: Sheet? = nil
    
    private var readBookmarks: [Bookmark] { folder.bookmarks.filter(\.isRead) }
    private var unreadBookmarks: [Bookmark] {
        folder.bookmarks
            // The second statement filters out the new bookmark while it's editing.
            .filter { $0.readDate == nil && !$0.title.isEmpty }
            .sorted(by: folder.sorting.predicate)
    }
    
    var body: some View {
        VStack {
            // Checking this condtion instead of `folder.bookmarks.isEmpty` is important here, to
            // retain the side effects of `unreadBookmarks`.
            if unreadBookmarks.isEmpty && readBookmarks.isEmpty {
                NoBookmarks /*onTapGesture:*/ {
                    let newBookmark = Bookmark(title: "", url: URL(string: "https://your.url")!, folderID: folder.id)
                    folder.bookmarks.insert(newBookmark, at: 0)
                    sheet = .new(bookmark: $folder.bookmarks[permanent: newBookmark.id])
                }
            }
            
            List {
                if !unreadBookmarks.isEmpty {
                    Section(header: Text("Unread")) {
                        ForEach(unreadBookmarks) { bookmark in
                            BookmarkRow(bookmark: bookmark)
                                .contextMenu {
                                    ContextMenu(bookmark: $folder.bookmarks[permanent: bookmark.id], editMode: $editMode)
                                        .onEdit { sheet = .edit(bookmark: $0) }
                                }
                        }
                        .onDelete(perform: onDelete(for: unreadBookmarks))
                        .onMove(perform: onMove(offsets:destination:))
                    }
                }
                
                if !readBookmarks.isEmpty {
                    Section(header: Text("Read")) {
                        ForEach(readBookmarks) { bookmark in
                            BookmarkRow(bookmark: bookmark)
                                .contextMenu {
                                    ContextMenu(bookmark: $folder.bookmarks[permanent: bookmark.id], editMode: $editMode)
                                        .onEdit { sheet = .edit(bookmark: $0) }
                                }
                        }
                        .onDelete(perform: onDelete(for: readBookmarks))
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(trailing:
                Group {
                    if (editMode != .inactive) {
                        Button("Done") { withAnimation { editMode = .inactive } }
                    } else {
                        Picker(selection: $folder.sorting, label: Image(systemName: "arrow.up.arrow.down.circle.fill")) {
                            ForEach(Folder.Sorting.allCases) { sorting in
                                Label(sorting.rawValue, systemImage: sorting.iconName)
                                    .tag(sorting)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
            )
            .environment(\.editMode, Binding($editMode))
            .sheet(item: $sheet) { sheet in
                switch sheet {
                case .new(let bookmark):
                    BookmarkEditor(title: "New Bookmark", bookmark: bookmark) { action in
                        if case .rejection = action { folder.bookmarks.remove(at: 0) }
                    }
                case .edit(let bookmark):
                    BookmarkEditor(title: "Edit Bookmark", bookmark: bookmark)
                }
            }
        }
        .navigationBarTitle(folder.name, displayMode: .inline)
    }
    
    private func onDelete(for bookmarks: [Bookmark]) -> ((IndexSet) -> Void)? {
        guard editMode == .inactive else { return nil }
        
        return { offsets in
            for offset in offsets {
                folder.bookmarks.remove(id: bookmarks[offset].id)
            }
        }
    }
    
    private func onMove(offsets: IndexSet, destination: Int) {
        let moveIsUp = offsets.contains { $0 < destination }
        
        // When moving items up the list (towards higher indices), the destination is 1 too high.
        // When moving items down the list (towards lower indices), the destination is fine.
        //
        // Since `move(fromOffsets:toOffsets)` requires the destination to be overshot by 1, and
        // we've explicitly removed that overshoot due to index mapping, we need to reintroduce it
        // in the final "proper" destination.
        /*let properDestination = unreadRows[destination + (moveIsUp ? -1 : 0)].index + (moveIsUp ? 1 : 0)
        let properOffsets = IndexSet(offsets.map { unreadRows[$0].index })
        
        folder.bookmarks.move(fromOffsets: properOffsets, toOffset: properDestination)*/
    }
}
