//
//  FolderDetail.Sheet.swift
//  Rede / App
//
//  Created by Marcus Rossel on 16.11.20.
//

import SwiftUI

extension FolderDetail {
    
    enum Sheet: View {
                
        case new(bookmark: Binding<Bookmark>, folder: Binding<Folder>)
        case edit(bookmark: Binding<Bookmark>)
        
        var body: some View {
            switch self {
            case let .new(bookmark, folder):
                BookmarkEditor(title: "New Bookmark", bookmark: bookmark) { action in
                    if case .rejection = action {
                        folder.wrappedValue.bookmarks.remove(at: 0)
                    }
                }
            case let .edit(bookmark):
                BookmarkEditor(title: "Edit Bookmark", bookmark: bookmark)
            }
        }
    }
}

// MARK: Identifiable

extension FolderDetail.Sheet: Identifiable {
    
    var id: Self { self }
}

// MARK: Equatable

extension FolderDetail.Sheet: Equatable {
    
    static func == (lhs: FolderDetail.Sheet, rhs: FolderDetail.Sheet) -> Bool {
        switch (lhs, rhs) {
        case let (.new(leftBookmark, leftFolder), .new(rightBookmark, rightFolder)):
            return leftBookmark.wrappedValue == rightBookmark.wrappedValue &&
                   leftFolder.wrappedValue   == rightFolder.wrappedValue
        case let (.edit(left), .edit(right)):
            return left.wrappedValue == right.wrappedValue
        default:
            return false
        }
    }
}

// MARK: Hashable

extension FolderDetail.Sheet: Hashable {
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .new(bookmark, folder):
            hasher.combine(bookmark.wrappedValue)
            hasher.combine(folder.wrappedValue)
        case let .edit(bookmark):
            hasher.combine(bookmark.wrappedValue)
        }
    }
}
