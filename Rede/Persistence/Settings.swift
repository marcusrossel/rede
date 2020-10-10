//
//  Settings.swift
//  Rede
//
//  Created by Marcus Rossel on 24.09.20.
//

import SwiftUI

final class Settings: NSObject, ObservableObject, Storage {
    
    @Published var language: Language = .english {
        didSet { didSet(language, for: \.language) }
    }
    
    @Published var showReadBookmarks: Bool = true {
        didSet { didSet(showReadBookmarks, for: \.showReadBookmarks) }
    }
    
    @Published var automaticallyNameBookmarks: Bool = true {
        didSet { didSet(automaticallyNameBookmarks, for: \.automaticallyNameBookmarks) }
    }
    
    // MARK: - Storage Protocol
    
    enum Key: String, CaseIterable {
        case language
        case showReadBookmarks
        case automaticallyNameBookmarks
    }
    
    func key(for path: PartialKeyPath<Settings>) -> Key {
        switch path {
        case \Settings.language:                   return .language
        case \Settings.showReadBookmarks:          return .showReadBookmarks
        case \Settings.automaticallyNameBookmarks: return .automaticallyNameBookmarks
        default:                                   fatalError()
        }
    }
    
    func set(_ data: Data, forKey key: Key) {
        switch key {
        case .language:                   set(\.language, from: data)
        case .showReadBookmarks:          set(\.showReadBookmarks, from: data)
        case .automaticallyNameBookmarks: set(\.automaticallyNameBookmarks, from: data)
        }
    }
    
    override init() {
        super.init()
        
        `init`(\.language)
        `init`(\.showReadBookmarks)
        `init`(\.automaticallyNameBookmarks)
    }
}

