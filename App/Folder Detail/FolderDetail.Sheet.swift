//
//  FolderDetail.Sheet.swift
//  Rede / App
//
//  Created by Marcus Rossel on 16.11.20.
//

import SwiftUI

extension FolderDetail {
    
    enum Sheet: View {
        
        private var storage: Storage { .shared }
                
        case new(bookmark: Binding<Bookmark>)
        case edit(bookmark: Binding<Bookmark>)
        
        var body: some View {
            switch self {
            case let .new(bookmark):
                BookmarkEditor(title: "New Bookmark", bookmark: bookmark) { _ in
                    bookmark.wrappedValue = Bookmark(title: "", url: URL(string: "https://your.url")!, folderID: nil)
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
        case let (.new(left), .new(right)):   return left.wrappedValue == right.wrappedValue
        case let (.edit(left), .edit(right)): return left.wrappedValue == right.wrappedValue
        default:                              return false
        }
    }
}

// MARK: Hashable

extension FolderDetail.Sheet: Hashable {
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .new(bookmark):
            hasher.combine("new")
            hasher.combine(bookmark.wrappedValue)
        case let .edit(bookmark):
            hasher.combine("edit")
            hasher.combine(bookmark.wrappedValue)
        }
    }
}
