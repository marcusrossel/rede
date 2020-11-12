//
//  Folder.swift
//  Rede / Common
//
//  Created by Marcus Rossel on 29.08.20.
//

import Foundation

struct Folder: Identifiable, Hashable, Codable {
    
    typealias ID = UUID
    
    let id: ID
    var name: String
    var bookmarks: [Bookmark]
    var sorting: Sorting
    var icon: Icon
    
    init(
        id: ID = ID(),
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

