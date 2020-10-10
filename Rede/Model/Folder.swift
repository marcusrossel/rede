//
//  Folder.swift
//  Rede
//
//  Created by Marcus Rossel on 29.08.20.
//

import SwiftUI

struct Folder: Identifiable {
    
    init(
        id: UUID = UUID(),
        name: String,
        bookmarks: [Bookmark] = [],
        sorting: Sorting = .byDate,
        icon: (name: String, color: Color) = (name: "folder.fill", color: Color(.systemBlue))
    ) {
        self.id = id
        self.name = name
        self.bookmarks = bookmarks
        self.sorting = sorting
        self.icon = icon
    }
    
    let id: UUID
    var name: String
    var bookmarks: [Bookmark]
    var sorting: Sorting
    var icon: (name: String, color: Color)
    
    var unreadBookmarks: [Bookmark] {
        bookmarks.filter { !$0.hasBeenRead }.sorted(by: sorting.predicate)
    }
    var readBookmarks: [Bookmark] {
        bookmarks.filter { $0.hasBeenRead }.sorted(by: sorting.predicate)
    }
}

// MARK: - Folder Sorting

extension Folder {
    
    enum Sorting: String, CaseIterable, Identifiable, Hashable, Codable {
        
        case manual = "Manual"
        case byDate = "By Date"
        case byTitle = "By Title"
        
        var id: String { rawValue }
        
        var iconName: String {
            switch self {
            case .manual: return "hand.tap.fill"
            case .byDate: return "calendar.badge.clock"
            case .byTitle: return "abc"
            }
        }
        
        var predicate: (Bookmark, Bookmark) -> Bool {
            return { lhs, rhs in
                switch self {
                case .manual: return true
                case .byDate: return lhs.additionDate > rhs.additionDate
                case .byTitle: return lhs.title < rhs.title
                }
            }
        }
    }
}

// MARK: - Hashing

extension Folder: Hashable {
    
    static func == (lhs: Folder, rhs: Folder) -> Bool { lhs.id == rhs.id }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(bookmarks)
        hasher.combine(sorting)
        hasher.combine(icon.name)
        hasher.combine(icon.color)
    }
}

// MARK: - Coding

extension Folder: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case bookmarks
        case sorting
        case iconName
        case iconColorRedComponent
        case iconColorGreenComponent
        case iconColorBlueComponent
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        bookmarks = try container.decode([Bookmark].self, forKey: .bookmarks)
        sorting = try container.decode(Sorting.self, forKey: .sorting)
        
        let red = try container.decode(Double.self, forKey: .iconColorRedComponent)
        let green = try container.decode(Double.self, forKey: .iconColorGreenComponent)
        let blue = try container.decode(Double.self, forKey: .iconColorBlueComponent)
        let iconColor = Color(red: red, green: green, blue: blue)
        let iconName = try container.decode(String.self, forKey: .iconName)
        
        icon = (name: iconName, color: iconColor)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
    
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(bookmarks, forKey: .bookmarks)
        try container.encode(sorting, forKey: .sorting)
        try container.encode(icon.name, forKey: .iconName)
        
        var (red, green, blue): (CGFloat, CGFloat, CGFloat) = (0, 0, 0)
        UIColor(icon.color).getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        try container.encode(Double(red), forKey: .iconColorRedComponent)
        try container.encode(Double(green), forKey: .iconColorGreenComponent)
        try container.encode(Double(blue), forKey: .iconColorBlueComponent)
    }
}
