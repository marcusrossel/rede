//
//  Binding+Subscripts.swift
//  Rede / Common
//
//  Created by Marcus Rossel on 09.11.20.
//

import SwiftUI

extension Binding where Value: MutableCollection {
    
    subscript(fixed index: Value.Index) -> Binding<Value.Element> {
        Binding<Value.Element> {
            self.wrappedValue[index]
        } set: {
            self.wrappedValue[index] = $0
        }
    }
}

extension Binding where Value: MutableCollection, Value.Element: Identifiable {
    
    subscript(permanent id: Value.Element.ID) -> Binding<Value.Element> {
        Binding<Value.Element> {
            self.wrappedValue.first { $0.id == id }!
        } set: {
            // RACE CONDITION
            let index = self.wrappedValue.firstIndex { $0.id == id }!
            self.wrappedValue[index] = $0
        }
    }

    subscript(volatile id: Value.Element.ID) -> Binding<Value.Element?> {
        Binding<Value.Element?> {
            self.wrappedValue.first { $0.id == id }
        } set: {
            // RACE CONDITION
            guard
                let newValue = $0,
                let index = self.wrappedValue.firstIndex(where: { $0.id == id })
            else { return }
            self.wrappedValue[index] = newValue
        }
    }
}
