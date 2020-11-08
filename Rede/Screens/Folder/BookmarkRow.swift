//
//  BookmarkRow.swift
//  Rede
//
//  Created by Marcus Rossel on 30.08.20.
//

import SwiftUI

struct BookmarkRow: View {
    
    @Binding var bookmark: Bookmark
    @Binding var folder: Folder
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Spacer()
                
                Link(bookmark.title, destination: bookmark.url)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(alignment: .firstTextBaseline) {
                    if let host = bookmark.url.host {
                        Text(host)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if false /*showFolder*/ {
                        HStack {
                            Image(systemName: folder.icon.name)
                                .foregroundColor(folder.icon.color)
                            
                            Text(folder.name)
                                .foregroundColor(.secondary)
                        }
                        .font(.footnote)
                    }
                }
                
                Spacer()
            }
        }
        .contextMenu {
            Button(action: move) {
                Text("Change Folder")
                Image(systemName: "folder.fill")
            }
            
            Button(action: rename) {
                Text("Rename")
                Image(systemName: "pencil")
            }
            
            Button(action: mark) {
                Text("Mark As \(folder.bookmarks.read.contains(bookmark) ? "Unread" : "Read")")
                Image(systemName: folder.bookmarks.read.contains(bookmark) ? "xmark" : "checkmark")
            }
            
            Button(action: delete) {
                Text("Delete")
                Image(systemName: "minus.circle")
            }
            .foregroundColor(.red)
        }
    }
    
    private func move() {
        
    }
    
    private func rename() {
        
    }
    
    private func mark() {
        if let index = folder.bookmarks.read.firstIndex(of: bookmark) {
            folder.bookmarks.read.remove(at: index)
            folder.bookmarks.unread.insert(bookmark, at: 0)
        } else if let index = folder.bookmarks.unread.firstIndex(of: bookmark) {
            folder.bookmarks.unread.remove(at: index)
            folder.bookmarks.read.insert(bookmark, at: 0)
        } else {
            fatalError("Bookmark '\(bookmark.title)' is not in the folder '\(folder.name)'.")
        }
    }
    
    private func delete() {
        if let index = folder.bookmarks.read.firstIndex(of: bookmark) {
            folder.bookmarks.read.remove(at: index)
        } else if let index = folder.bookmarks.unread.firstIndex(of: bookmark) {
            folder.bookmarks.unread.remove(at: index)
        } else {
            fatalError("Bookmark '\(bookmark.title)' is not in the folder '\(folder.name)'.")
        }
    }
}

// MARK: Previews

struct BookmarkRow_Previews: PreviewProvider {
    
    static var previews: some View {
        StatefulPreview()
    }
    
    /// A `View` that is used for the preview, as `@State` doesn't work on non-`View`s.
    struct StatefulPreview: View {
        
        @State private var folder = Folder.previewData[1]
        
        var body: some View {
            List(folder.bookmarks.all) { bookmark in
                BookmarkRow(bookmark: $folder.bookmarks.read[0], folder: $folder)
            }
            .listStyle(GroupedListStyle())
        }
    }
}
