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
    private var readRows: [Row<Bookmark>] {
        folder.bookmarks.indexed().filter { $0.element.readDate != nil }
    }
    
    @State private var sheet: Sheet?
    @State private var isReordering = false
    
    @State private var newBookmark = Bookmark(title: "", url: URL(string: "https://your.url")!)
    
    var body: some View {
        VStack {
            if unreadRows.isEmpty && readRows.isEmpty {
                Spacer()
                
                VStack(spacing: 12) {
                    Button {
                        folder.bookmarks.insert(newBookmark, at: 0)
                        sheet = .newBookmark
                    } label: {
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color(#colorLiteral(red: 0.3895070553, green: 0.7931495309, blue: 0.4028683305, alpha: 1)))
                            .overlay(
                                Image(systemName: "plus")
                                    .font(Font.system(size: 20).bold())
                                    .padding(.bottom, 12)
                                    .foregroundColor(Color(.systemBackground))
                            )
                    }
                    
                    Text("No bookmarks yet?\nTry adding one!")
                        .fontWeight(.bold)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(40)
            }
            
            List {
                if !unreadRows.isEmpty {
                    Section(header: Text("Unread")) {
                        ForEach(unreadRows) { row in
                            if row.element != newBookmark {
                                BookmarkRow(bookmark: row.element)
                                    .contextMenu { isReordering ? nil : contextMenu(for: row) }
                            }
                        }
                        .onDelete(perform: isReordering ? nil : { delete(atOffsets: $0, areRead: false) })
                        .onMove(perform: onMove(offsets:destination:))
                    }
                }
                
                if !readRows.isEmpty {
                    Section(header: Text("Read")) {
                        ForEach(readRows) { row in
                            BookmarkRow(bookmark: row.element)
                                .contextMenu { isReordering ? nil : contextMenu(for: row) }
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
                case .newBookmark:
                    BookmarkEditor(row: Row(index: 0, element: newBookmark), in: $folder) { completion in
                        if case .cancel = completion { folder.bookmarks.remove(at: 0) }
                        newBookmark = Bookmark(title: "", url: URL(string: "https://your.url")!)
                    }
                case .edit(let row):
                    BookmarkEditor(row: row, in: $folder)
                }
            }
        }
        .navigationBarTitle(folder.name, displayMode: .inline)
    }
    
    private func delete(atOffsets offsets: IndexSet, areRead: Bool) {
        let properOffsets = IndexSet(offsets.map { (areRead ? readRows[$0] : unreadRows[$0]).index })
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
    
    private func contextMenu(for row: Row<Bookmark>) -> some View {
        Group {
            let isUnread = row.element.readDate == nil
            
            Button {
                folder.bookmarks[row.index].readDate = isUnread ? Date() : nil
            } label: {
                Text("Mark As \(isUnread ? "Read" : "Unread")")
                Image(systemName: "book\(isUnread ? ".fill" : "")")
            }
            
            Button {
                folder.bookmarks[row.index].isFavorite.toggle()
            } label: {
                Text(row.element.isFavorite ? "Unfavorite" : "Favorite")
                Image(systemName: "star\(row.element.isFavorite ? "" : ".fill")")
            }
            
            Button { sheet = .edit(row: row) } label: {
                Text("Edit")
                Image(systemName: "slider.horizontal.3")
            }
            
            if isUnread && unreadRows.count > 1 && folder.sorting == .manual {
                Button { withAnimation { isReordering = true } } label: {
                    Text("Reorder")
                    Image(systemName: "rectangle.arrowtriangle.2.outward")
                }
            }
            
            Button {
                folder.bookmarks.remove(at: row.index)
            } label: {
                Text("Delete")
                Image(systemName: "minus.circle.fill")
            }
        }
    }
}

// MARK: Sheet

extension FolderDetail {
    
    enum Sheet: Identifiable, Hashable {
        
        case newBookmark
        case edit(row: Row<Bookmark>)
        
        var id: Sheet { self }
    }
}
