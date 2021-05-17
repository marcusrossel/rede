//
//  BookmarkCollectionDetail.swift
//  Rede / App
//
//  Created by Marcus Rossel on 11.12.20.
//

import SwiftUI

struct BookmarkCollectionDetail: View {
    
    @StateObject private var storage: Storage = .shared
    @Binding var collection: [Bookmark]
    
    @Environment(\.editMode) private var editMode
    @State private var sheet: FolderDetail.Sheet? = nil
    @State private var newBookmark = Bookmark(title: "", url: URL(string: "https://your.url")!, folderID: nil)
    
    private var readBookmarks: [Bookmark] { collection.filter(\.isRead) }
    private var unreadBookmarks: [Bookmark] {
        [] // folder.sorting.applied(to: collection.filter { !$0.isRead })
    }
    
    var body: some View {
        EmptyView()
    }
}
