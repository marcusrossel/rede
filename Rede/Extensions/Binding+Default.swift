//
//  Binding+Default.swift
//  Rede
//
//  Created by Marcus Rossel on 21.10.20.
//

import SwiftUI

extension Binding where Value: RandomAccessCollection & MutableCollection {
    
    subscript(_ index: Value.Index, default default: Value.Element) -> Binding<Value.Element> {
        Binding<Value.Element> {
            guard wrappedValue.indices.contains(index) else { return `default` }
            return wrappedValue[index]
        } set: {
            wrappedValue[index] = $0
        }
    }
}

extension Binding where Value: RandomAccessCollection & MutableCollection, Value.Element: Defaultable {
    
    subscript(_ index: Value.Index) -> Binding<Value.Element> {
        projectedValue[index, default: Value.Element.default]
    }
}

protocol Defaultable {
    
    static var `default`: Self { get }
}

extension Folder: Defaultable {
    static var `default` = Folder(name: "")
}

extension Bookmark: Defaultable {
    static var `default` = Bookmark(title: "", url: URL(string: "http://marcusrossel.com")!)
}
