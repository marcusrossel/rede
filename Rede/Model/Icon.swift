//
//  Icon.swift
//  Rede
//
//  Created by Marcus Rossel on 16.10.20.
//

import SwiftUI

struct Icon: Hashable {
    
    var name: String
    var color: Color
    
    init(name: String, color: Color) {
        self.name = name
        self.color = color
    }
    
    init(name: String, uiColor: UIColor) {
        self.init(name: name, color: Color(uiColor))
    }
}

// MARK: Defaults

extension Icon {
    
    static let folder = Icon(name: "folder.fill", uiColor: .systemBlue)
}

    
// MARK: Coding

extension Icon: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case name
        case colorRedComponent
        case colorGreenComponent
        case colorBlueComponent
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        
        let red = try container.decode(Double.self, forKey: .colorRedComponent)
        let green = try container.decode(Double.self, forKey: .colorGreenComponent)
        let blue = try container.decode(Double.self, forKey: .colorBlueComponent)
        let color = Color(red: red, green: green, blue: blue)
        self.color = color
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
    
        try container.encode(name, forKey: .name)
        
        var (red, green, blue): (CGFloat, CGFloat, CGFloat) = (0, 0, 0)
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        try container.encode(Double(red), forKey: .colorRedComponent)
        try container.encode(Double(green), forKey: .colorGreenComponent)
        try container.encode(Double(blue), forKey: .colorBlueComponent)
    }
}
