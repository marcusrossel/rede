//
//  Bookmark.swift
//  Rede
//
//  Created by Marcus Rossel on 29.08.20.
//

import Foundation

// MARK: - Bookmark

struct Bookmark: Codable, Hashable {
    
    var title: String
    let url: URL
    let additionDate: Date
    var readDate: Date?
    
    var hasBeenRead: Bool {
        get { readDate != nil }
        set { readDate = newValue ? Date() : nil }
    }

    init(
        title: String,
        url: URL,
        additionDate: Date = Date(),
        readDate: Date? = nil
    ) {
        self.title = title
        self.url = url
        self.additionDate = additionDate
        self.readDate = readDate
    }
}

// MARK: - Bookmark ID

extension Bookmark: Identifiable {
    
    var id: ID { ID(url: url, additionDate: additionDate) }
    
    struct ID: Hashable {
        let url: URL
        let additionDate: Date
    }
}
