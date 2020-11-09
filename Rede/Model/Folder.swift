//
//  Folder.swift
//  Rede
//
//  Created by Marcus Rossel on 29.08.20.
//

import SwiftUI

// MARK: Folder

struct Folder: Identifiable, Hashable, Codable {
    
    var name: String
    var bookmarks: [Bookmark] = []
    var sorting = Sorting.manual
    var icon = Icon.folder
    
    var id: String { name }
}

// MARK: Folder Sorting

extension Folder {
    
    enum Sorting: String, CaseIterable, Identifiable, Hashable, Codable {
        
        case manual = "Manual"
        case byDate = "By Date"
        case byTitle = "By Title"
        
        var id: String { rawValue }
        
        var iconName: String {
            switch self {
            case .manual: return "rectangle.arrowtriangle.2.outward"
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
