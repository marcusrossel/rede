//
//  Shelf.swift
//  Rede
//
//  Created by Marcus Rossel on 05.09.20.
//

import SwiftUI

final class Shelf: NSObject, ObservableObject, Storage {
    
    @Published var folders: [Folder] = [] {
        didSet { didSet(folders, for: \.folders) }
    }
    
    // MARK: - Storage Protocol
    
    enum Key: String, CaseIterable {
        case folders
    }
    
    func key(for path: PartialKeyPath<Shelf>) -> Key {
        switch path {
        case \Shelf.folders: return .folders
        default:             fatalError()
        }
    }
    
    func set(_ data: Data, forKey key: Key) {
        switch key {
        case .folders: set(\.folders, from: data)
        }
    }
    
    override init() {
        super.init()
        
        `init`(\.folders)
    }
}
