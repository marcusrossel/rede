//
//  Array+Subscripts.swift
//  Rede / Common
//
//  Created by Marcus Rossel on 12.11.20.
//

extension Array where Element: Identifiable {
    
    subscript(permanent id: Element.ID) -> Element {
        get {
            first { $0.id == id }!
        }
        set {
            // RACE CONDITION
            let index = firstIndex { $0.id == id }!
            self[index] = newValue
        }
    }

    subscript(volatile id: Element.ID) -> Element? {
        get {
            first { $0.id == id }
        }
        set {
            // RACE CONDITION
            guard
                let newValue = newValue,
                let index = firstIndex(where: { $0.id == id })
            else { return }
            self[index] = newValue
        }
    }
    
    mutating func remove(id: Element.ID?) {
        guard let index = firstIndex(where: { $0.id == id }) else { return }
        remove(at: index)
    }
}
