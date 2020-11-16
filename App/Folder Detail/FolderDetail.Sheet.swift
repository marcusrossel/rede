//
//  FolderDetail.Sheet.swift
//  Rede
//
//  Created by Marcus Rossel on 16.11.20.
//

import SwiftUI

extension FolderDetail {
    
    enum Sheet: Identifiable, Equatable, Hashable {
                
        case new(bookmark: Binding<Bookmark>)
        case edit(bookmark: Binding<Bookmark>)
        
        var id: Sheet { self }
        
        static func == (lhs: FolderDetail.Sheet, rhs: FolderDetail.Sheet) -> Bool {
            switch (lhs, rhs) {
            case let (.new(left), .new(right)):   return left.wrappedValue == right.wrappedValue
            case let (.edit(left), .edit(right)): return left.wrappedValue == right.wrappedValue
            default:                              return false
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .new(let bookmark):  hasher.combine(bookmark.wrappedValue)
            case .edit(let bookmark): hasher.combine(bookmark.wrappedValue)
            }
        }
    }
}
