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

// MARK: Language

extension Settings {

    enum Language: String, CaseIterable, Identifiable, Codable {

        case german = "Deutsch"
        case english = "English"
        case norwegian = "Norsk (Bokmål)"
        
        var id: Language { return self }
    }
}
