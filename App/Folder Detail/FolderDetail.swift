//
//  FolderDetail.swift
//  Rede / App
//
//  Created by Marcus Rossel on 08.11.20.
//

import SwiftUI

struct FolderDetail: View {
    
    init(row: Row<Folder>) {
        _storage = StateObject(wrappedValue: Storage.shared)
        
        // This is really a manual implementation of `Binding.suscript(safe:)`.
        _folder = Binding<Folder> {
            guard Storage.shared.folders.indices.contains(row.index) else { return row.element }
            return Storage.shared.folders[row.index]
        } set: { newValue in
            guard Storage.shared.folders.indices.contains(row.index) else { return }
            Storage.shared.folders[row.index] = newValue
        }
    }
    
    @StateObject private var storage: Storage
    @Binding private var folder: Folder
    
    private var unreadRows: [Row<Bookmark>] {
        let filtered = folder.bookmarks.indexed()
            .filter {
                $0.element.readDate == nil &&
                !$0.element.title.isEmpty // Filters out the new bookmark while it's editing.
            }
            
        switch folder.sorting {
        case .manual:
            return filtered
        default:
            return filtered.sorted { lhs, rhs in folder.sorting.predicate(lhs.element, rhs.element) }
        }
    }
    private var readBookmarks: [Bookmark] { folder.bookmarks.filter(\.isRead) }
    
    @State private var sheet: Sheet?
    @State private var isReordering = false
    
    var body: some View {
        VStack {
            if unreadRows.isEmpty && readBookmarks.isEmpty {
                NoBookmarks /*onTapGesture:*/ {
                    let newBookmark = Bookmark(
                        title: "",
                        url: URL(string: "https://your.url")!,
                        folderID: folder.id
                    )
                    folder.bookmarks.insert(newBookmark, at: 0)
                    sheet = .new(bookmark: $folder.bookmarks[permanent: newBookmark.id])
                }
            }
            
            List {
                if !unreadRows.isEmpty {
                    Section(header: Text("Unread")) {
                        ForEach(unreadRows) { row in
                            BookmarkRow(bookmark: row.element)
                                .contextMenu {
                                    if !isReordering {
                                        ContextMenu(bookmark: $folder.bookmarks[row.index])
                                            .onEdit { sheet = .edit(bookmark: $0) }
                                            .onReorder { withAnimation { isReordering = true } }
                                    }
                                }
                        }
                        .onDelete(perform: isReordering ? nil : { delete(atOffsets: $0, areRead: false) })
                        .onMove(perform: onMove(offsets:destination:))
                    }
                }
                
                if !readBookmarks.isEmpty {
                    Section(header: Text("Read")) {
                        ForEach(readBookmarks) { bookmark in
                            BookmarkRow(bookmark: bookmark)
                                .contextMenu {
                                    if !isReordering {
                                        ContextMenu(bookmark: $folder.bookmarks[permanent: bookmark.id])
                                            .onEdit { sheet = .edit(bookmark: $0) }
                                            .onReorder { withAnimation { isReordering = true } }
                                    }
                                }
                        }
                        .onDelete(perform: isReordering ? nil : { delete(atOffsets: $0, areRead: true) })
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(trailing:
                Group {
                    if isReordering {
                        Button("Done") { withAnimation { isReordering = false } }
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
            .environment(\.editMode, .constant(isReordering ? .active : .inactive))
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
    
    private func delete(atOffsets offsets: IndexSet, areRead: Bool) {
        #warning("Broken")
        let properOffsets = IndexSet(offsets.map { (areRead ? readBookmarks[$0] : unreadRows[$0]).index })
        folder.bookmarks.remove(atOffsets: properOffsets)
    }
    
    private func onMove(offsets: IndexSet, destination: Int) {
        let moveIsUp = offsets.contains { $0 < destination }
        
        // When moving items up the list (towards higher indices), the destination is 1 too high.
        // When moving items down the list (towards lower indices), the destination is fine.
        //
        // Since `move(fromOffsets:toOffsets)` requires the destination to be overshot by 1, and
        // we've explicitly removed that overshoot due to index mapping, we need to reintroduce it
        // in the final "proper" destination.
        let properDestination = unreadRows[destination + (moveIsUp ? -1 : 0)].index + (moveIsUp ? 1 : 0)
        let properOffsets = IndexSet(offsets.map { unreadRows[$0].index })
        
        folder.bookmarks.move(fromOffsets: properOffsets, toOffset: properDestination)
    }
}
