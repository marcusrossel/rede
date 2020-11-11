//
//  Binding+Safe.swift
//  Rede / Common
//
//  Created by Marcus Rossel on 09.11.20.
//

import SwiftUI

// https://blog.apptekstudios.com/2020/05/quick-tip-avoid-crash-when-using-foreach-bindings-in-swiftui/
extension Binding where Value: MutableCollection {
  
    subscript(safe index: Value.Index) -> Binding<Value.Element> {
        // Get the value of the element when we first create the binding
        // Thus we have a 'placeholder-value' if `get` is called when the index no longer exists
        let safety = wrappedValue[index]
    
        return Binding<Value.Element> {
            // If this index no longer exists, return a dummy value
            guard self.wrappedValue.indices.contains(index) else { return safety }
            return self.wrappedValue[index]
        } set: { newValue in
            //If this index no longer exists, do nothing
            guard self.wrappedValue.indices.contains(index) else { return }
            self.wrappedValue[index] = newValue
        }
    }
}
