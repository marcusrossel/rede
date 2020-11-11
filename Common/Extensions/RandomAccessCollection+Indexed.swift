//
//  RandomAccessCollection+Indexed.swift
//  Rede / Common
//
//  Created by Marcus Rossel on 18.10.20.
//

// MARK: Extension

extension RandomAccessCollection {
    
    func indexed() -> IndexedCollection<Self> {
        IndexedCollection(base: self)
    }
}

// MARK: Indexed Collection

/// https://developer.apple.com/documentation/ios-ipados-release-notes/ios-13-release-notes#3359765
struct IndexedCollection<Base: RandomAccessCollection>: RandomAccessCollection {
    
    typealias Index = Base.Index
    
    let base: Base

    var startIndex: Index { base.startIndex }

    var endIndex: Index { base.endIndex }

    func index(after i: Index) -> Index {
        base.index(after: i)
    }

    func index(before i: Index) -> Index {
        base.index(before: i)
    }

    func index(_ i: Index, offsetBy distance: Int) -> Index {
        base.index(i, offsetBy: distance)
    }

    subscript(position: Index) -> Element {
        .init(index: position, element: base[position])
    }
}

// MARK: Indexed Collection Element

extension IndexedCollection {
    
    struct Element {
        
        let index: Index
        let element: Base.Element
    }
}

extension IndexedCollection.Element: Equatable, Hashable, Identifiable
where Base.Element: Hashable & Identifiable, Base.Index: Hashable {

    var id: Base.Element { element }
}

