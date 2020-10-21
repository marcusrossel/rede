//
//  Settings.swift
//  Rede
//
//  Created by Marcus Rossel on 15.10.20.
//

// MARK: Settings

struct Settings: Codable {
    
    static let key = "settings"
    
    var language = Language.english
    var showReadBookmarks = true
    var automaticallyMarkAsRead = false
    var automaticallyNameBookmarks = true
}
