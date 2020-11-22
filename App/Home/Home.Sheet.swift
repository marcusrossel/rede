//
//  Home.Sheet.swift
//  Rede / App
//
//  Created by Marcus Rossel on 17.11.20.
//

import SwiftUI

extension Home {
    
    enum Sheet: View {
        
        private var storage: Storage { .shared }
        
        case new(folder: Binding<Folder>)
        case edit(folder: Binding<Folder>)
        case merge(folder: Binding<Folder>)
        
        var body: some View {
            switch self {
            case .new(let folder):
                FolderEditor(folder: folder) { action in
                    if case .acceptance = action { storage.folders.insert(folder.wrappedValue, at: 0) }
                    folder.wrappedValue = Folder(name: "")
                }
            case .edit(let folder):
                FolderEditor(folder: folder)
            case .merge(let folder):
                FolderMerger(source: folder)
            }
        }
    }
}

// MARK: Identifiable

extension Home.Sheet: Identifiable {
    
    var id: Self { self }
}

// MARK: Equatable

extension Home.Sheet: Equatable {
    
    static func == (lhs: Home.Sheet, rhs: Home.Sheet) -> Bool {
        switch (lhs, rhs) {
        case let (.new(left), .new(right)):     return left.wrappedValue == right.wrappedValue
        case let (.edit(left), .edit(right)):   return left.wrappedValue == right.wrappedValue
        case let (.merge(left), .merge(right)): return left.wrappedValue == right.wrappedValue
        default:                                return false
        }
    }
}

// MARK: Hashable

extension Home.Sheet: Hashable {
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .new(folder):
            hasher.combine("new")
            hasher.combine(folder.wrappedValue)
        case let .edit(folder):
            hasher.combine("edit")
            hasher.combine(folder.wrappedValue)
        case let .merge(folder):
            hasher.combine("merge")
            hasher.combine(folder.wrappedValue)
        }
    }
}


