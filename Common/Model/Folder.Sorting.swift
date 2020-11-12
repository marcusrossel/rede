//
//  Folder.Sorting.swift
//  Rede / Common
//
//  Created by Marcus Rossel on 12.11.20.
//

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
                case .byTitle: return lhs.title.lowercased() < rhs.title.lowercased()
                }
            }
        }
    }
}

