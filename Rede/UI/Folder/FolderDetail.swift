//
//  FolderDetail.swift
//  Rede
//
//  Created by Marcus Rossel on 08.11.20.
//

import SwiftUI

struct FolderDetail: View {
    
    // This binding is passed via a navigation link. Bindings and navigation links don't interact well:
    // https://forums.swift.org/t/swiftui-bindings-does-reading-them-in-body-mean-view-will-re-render/34600/10
    // So in the meantime access the storage from this view directly.
    @Binding var _folder: Folder
    @StateObject private var storage: Storage = .shared
    private var folder: Binding<Folder> {
        Binding {
            storage.folders.first { $0.id == _folder.id }!
        } set: { newValue in
            let index = storage.folders.firstIndex { $0.id == newValue.id }!
            storage.folders[index] = newValue
        }
    }
    
    private var unreadRows: [Row<Bookmark>] {
        folder.wrappedValue.bookmarks.indexed()
            .filter { $0.element.readDate == nil }
            .sorted { lhs, rhs in folder.wrappedValue.sorting.predicate(lhs.element, rhs.element) }
    }
    private var readRows: [Row<Bookmark>] {
        folder.wrappedValue.bookmarks.indexed().filter { $0.element.readDate != nil }
    }
    
    @State private var rowInEdit: Row<Bookmark>?
    @State private var isReordering = false
    
    var body: some View {
        if unreadRows.isEmpty && readRows.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "bookmark.slash")
                    .font(.system(.largeTitle))
                Text("No Bookmarks")
                    .fontWeight(.bold)
                    .font(.title3)
            }
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding()
            .navigationBarTitle(folder.wrappedValue.name, displayMode: .inline)
        } else {
            List {
                if !unreadRows.isEmpty {
                    Section(header: Text("Unread")) {
                        ForEach(unreadRows) { row in
                            BookmarkRow(bookmark: row.element)
                                .contextMenu { isReordering ? nil : contextMenu(for: row) }
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
            .navigationBarTitle(folder.wrappedValue.name, displayMode: .inline)
            .navigationBarItems(trailing: isReordering
                ? AnyView(Button("Done") { withAnimation { isReordering = false } })
                : AnyView(EmptyView())
            )
            .environment(\.editMode, .constant(isReordering ? .active : .inactive))
            .sheet(item: $rowInEdit) { row in
                BookmarkEditor(bookmark: folder.bookmarks[row.index])
            }
        }
    }
    
    private func delete(atOffsets offsets: IndexSet, areRead: Bool) {
        let properOffsets = IndexSet(offsets.map { (areRead ? readRows[$0] : unreadRows[$0]).index })
        folder.wrappedValue.bookmarks.remove(atOffsets: properOffsets)
    }
    
    private func onMove(offsets: IndexSet, destination: Int) {
        #warning("This is broken?")
        let properOffsets = IndexSet(offsets.map { unreadRows[$0].index })
        let properDestination = unreadRows[safe: destination]?.index ?? folder.wrappedValue.bookmarks.endIndex
        folder.wrappedValue.bookmarks.move(fromOffsets: properOffsets, toOffset: properDestination)
    }
    
    private func contextMenu(for row: Row<Bookmark>) -> some View {
        Group {
            let isUnread = row.element.readDate == nil
            
            Button {
                folder.wrappedValue.bookmarks[row.index].readDate = isUnread ? Date() : nil
            } label: {
                Text("Mark As \(isUnread ? "Read" : "Unread")")
                Image(systemName: "bookmark\(isUnread ? ".fill" : "")")
            }
            
            Button {
                folder.wrappedValue.bookmarks[row.index].isFavorite.toggle()
            } label: {
                Text(row.element.isFavorite ? "Unfavorite" : "Favorite")
                Image(systemName: "star\(row.element.isFavorite ? "" : ".fill")")
            }
            
            Button { rowInEdit = row } label: {
                Text("Edit")
                Image(systemName: "slider.horizontal.3")
            }
            
            if isUnread && unreadRows.count > 1 && folder.wrappedValue.sorting == .manual {
                Button { withAnimation { isReordering = true } } label: {
                    Text("Reorder")
                    Image(systemName: "rectangle.arrowtriangle.2.outward")
                }
            }
            
            Button {
                folder.wrappedValue.bookmarks.remove(at: row.index)
            } label: {
                Text("Delete")
                Image(systemName: "minus.circle.fill")
            }
        }
    }
}
