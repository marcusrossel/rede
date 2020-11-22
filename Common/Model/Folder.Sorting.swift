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
        
        func applied(to bookmarks: [Bookmark]) -> [Bookmark] {
            switch self {
            case .manual:  return bookmarks
            case .byDate:  return bookmarks.sorted { $0.additionDate > $1.additionDate }
            case .byTitle: return bookmarks.sorted { $0.title.lowercased() < $1.title.lowercased() }
            }
        }
    }
}

