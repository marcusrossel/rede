//
//  FolderDetail.ContextMenu.swift
//  Rede / App
//
//  Created by Marcus Rossel on 16.11.20.
//

import SwiftUI

extension FolderDetail {
    
    struct ContextMenu: View {
        
        @StateObject private var storage: Storage = .shared
        @Binding var bookmark: Bookmark
        
        var editMode: Binding<EditMode>?
        var onEdit: (Binding<Bookmark>) -> Void
        
        private var folder: Folder {
            get { storage.folders[permanent: bookmark.folderID!] }
            nonmutating set { $storage.folders[permanent: bookmark.folderID!].wrappedValue = newValue }
        }
        
        private var showReorderButton: Bool {
            !bookmark.isRead &&
            folder.sorting == .manual &&
            folder.bookmarks.filter { !$0.isRead }.count > 1
        }
        
        var body: some View {
            switch editMode?.wrappedValue {
            case .active:
                EmptyView()
            default:
                Button {
                    withAnimation {
                        bookmark.readDate = bookmark.isRead ? nil : Date()
                        
                        // RACE CONDITION
                        let index = folder.bookmarks.firstIndex(of: bookmark)!
                        folder.bookmarks.move(fromOffsets: [index], toOffset: 0)
                    }
                } label: {
                    Text("Mark As \(bookmark.isRead ? "Unread" : "Read")")
                    Image(systemName: "book\(bookmark.isRead ? "" : ".fill")")
                }
                
                Button {
                    withAnimation {
                        bookmark.isFavorite.toggle()
                    }
                } label: {
                    Text(bookmark.isFavorite ? "Unfavorite" : "Favorite")
                    Image(systemName: "star\(bookmark.isFavorite ? "" : ".fill")")
                }
                
                Button { onEdit($bookmark) } label: {
                    Text("Edit")
                    Image(systemName: "slider.horizontal.3")
                }
                
                if showReorderButton {
                    Button {
                        withAnimation {
                            editMode?.wrappedValue = .active
                        }
                    } label: {
                        Text("Reorder")
                        Image(systemName: "rectangle.arrowtriangle.2.outward")
                    }
                }
                
                Button {
                    folder.bookmarks.remove(id: bookmark.id)
                } label: {
                    Text("Delete")
                    Image(systemName: "minus.circle.fill")
                }
            }
        }
    }
}
