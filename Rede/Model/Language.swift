//
//  Language.swift
//  Rede
//
//  Created by Marcus Rossel on 24.09.20.
//

enum Language: String, CaseIterable, Identifiable, Codable {

    case german = "Deutsch"
    case english = "English"
    case norwegian = "Norsk (Bokmål)"
    
    var id: Language { return self }
}

