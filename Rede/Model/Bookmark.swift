//
//  Bookmark.swift
//  Rede
//
//  Created by Marcus Rossel on 29.08.20.
//

import Foundation

// MARK: Bookmark

struct Bookmark: Codable, Identifiable, Hashable {
    
    let id: UUID
    var title: String
    var url: URL
    let additionDate: Date
    var readDate: Date?
    var isFavorite: Bool

    init(id: UUID = UUID(), title: String, url: URL, additionDate: Date = Date(), readDate: Date? = nil, isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.url = url
        self.additionDate = additionDate
        self.readDate = readDate
        self.isFavorite = isFavorite
    }
}
