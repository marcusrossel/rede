//
//  Collection+Safe.swift
//  Rede / Common
//
//  Created by Marcus Rossel on 09.11.20.
//

extension Collection {

    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
