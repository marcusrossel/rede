//
//  Folder.swift
//  Rede / Common
//
//  Created by Marcus Rossel on 29.08.20.
//

import Foundation

struct Folder: Identifiable, Hashable, Codable {

    let id: UUID
    var name: String
    var bookmarks: [Bookmark]
    var sorting: Sorting
    var icon: Icon
    
    init(
        id: UUID = UUID(),
        name: String,
        bookmarks: [Bookmark] = [],
        sorting: Sorting = .manual,
        icon: Icon = .folder
    ) {
        self.id = id
        self.name = name
        self.bookmarks = bookmarks
        self.sorting = sorting
        self.icon = icon
    }
}

