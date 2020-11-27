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
    
    @Environment(\.editMode) private var editMode
    @State private var sheet: Sheet? = nil
    @State private var newBookmark = Bookmark(title: "", url: URL(string: "https://your.url")!, folderID: nil)
    
    private var readBookmarks: [Bookmark] { folder.bookmarks.filter(\.isRead) }
    private var unreadBookmarks: [Bookmark] {
        folder.sorting.applied(to: folder.bookmarks.filter { !$0.isRead })
    }
    
    var body: some View {
        VStack {
            if folder.bookmarks.isEmpty {
                NoBookmarks /*onTapGesture:*/ {
                    sheet = .new(bookmark: $newBookmark)
                }
            }
            
            List {
                let sections = [\Self.unreadBookmarks, \.readBookmarks]
                ForEach(sections, id: \.self) { bookmarks in
                    if !self[keyPath: bookmarks].isEmpty {
                        Section(header: Text((bookmarks == \.unreadBookmarks) ? "Unread" : "Read")) {
                            ForEach(self[keyPath: bookmarks], id: \.self) { bookmark in
                                BookmarkRow(bookmark: bookmark)
                                    .contextMenu {
                                        ContextMenu(bookmark: $folder.bookmarks[permanent: bookmark.id], editMode: editMode) /*onEdit:*/ {
                                            sheet = .edit(bookmark: $0)
                                        }
                                    }
                            }
                            .onDelete(perform: onDelete(for: bookmarks))
                            .onMove(perform: (bookmarks == \.unreadBookmarks) ? onMove(offsets:destination:) : nil)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationBarTitle(folder.name, displayMode: .inline)
        .navigationBarItems(trailing: BarButton(folder: $folder, editMode: editMode))
        .sheet(item: $sheet) { $0 }
    }
    
    private func onDelete(for bookmarks: KeyPath<Self, [Bookmark]>) -> ((IndexSet) -> Void)? {
        switch editMode?.wrappedValue {
        case .active:
            return nil
        default:
            return { offsets in
                for offset in offsets {
                    // Since the bookmarks in this context are considered "permanent", their number
                    // can only stay constant or grow, so this direct subscript via `offset` is at
                    // least safe.
                    folder.bookmarks.remove(id: self[keyPath: bookmarks][offset].id)
                }
            }
        }
    }
    
    private func onMove(offsets: IndexSet, destination: Int) {
        let moveIsUp = offsets.contains { $0 < destination }
        
        // When moving items up the list (towards higher indices), the destination is 1 too high.
        // When moving items down the list (towards lower indices), the destination is fine.
        let destinationID = unreadBookmarks[destination + (moveIsUp ? -1 : 0)].id
        let offsetIDs = offsets.map { unreadBookmarks[$0].id }
        
        // Since `move(fromOffsets:toOffsets)` requires the destination to be overshot by 1, and
        // we've explicitly removed that overshoot due to index mapping, we need to reintroduce it
        // for the proper destination.
        //
        // Force unwrapping is ok here, since all bookmarks in this context are assumed permanent.
        let destinationIndex = folder.bookmarks.firstIndex { $0.id == destinationID }! + (moveIsUp ? 1 : 0)
        
        // Force unwrapping is ok here, since all bookmarks in this context are assumed permanent.
        let offsetIndices = offsetIDs.map { id in folder.bookmarks.firstIndex { $0.id == id }! }
        
        // RACE CONDITION
        folder.bookmarks.move(fromOffsets: IndexSet(offsetIndices), toOffset: destinationIndex)
    }
}
