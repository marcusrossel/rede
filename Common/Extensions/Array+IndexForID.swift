//
//  Array+IndexForID.swift
//  Rede
//
//  Created by Marcus Rossel on 12.11.20.
//

extension Array where Element: Identifiable {
    
    func index(id: Element.ID?) -> Index? {
        firstIndex { $0.id == id }
    }
    
    mutating func remove(id: Element.ID?) {
        guard let index = index(id: id) else { return }
        remove(at: index)
    }
}
