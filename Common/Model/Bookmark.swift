//
//  Bookmark.swift
//  Rede / Common
//
//  Created by Marcus Rossel on 29.08.20.
//

import Foundation

struct Bookmark: Codable, Identifiable, Hashable {
    
    let id: UUID
    var title: String
    var url: URL
    let additionDate: Date
    var readDate: Date?
    var isFavorite: Bool
    var folderID: Folder.ID?

    init(
        id: UUID = UUID(),
        title: String,
        url: URL,
        additionDate: Date = Date(),
        readDate: Date? = nil,
        isFavorite: Bool = false,
        folderID: Folder.ID? = nil
    ) {
        self.id = id
        self.title = title
        self.url = url
        self.additionDate = additionDate
        self.readDate = readDate
        self.isFavorite = isFavorite
        self.folderID = folderID
    }
}
