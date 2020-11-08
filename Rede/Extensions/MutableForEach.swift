//
//  MutableForEach.swift
//  Rede
//
//  Created by Marcus Rossel on 21.10.20.
//

import SwiftUI

struct MutableForEach<Data, Content>: DynamicViewContent
where Data: RandomAccessCollection & MutableCollection,
      Data.Element: Hashable & Identifiable,
      Data.Index: Hashable,
      Content: View {
    
    init(_ data: Binding<Data>, content: @escaping (Data.Element, Binding<Data.Element>) -> Content) {
        _data = data
        self.content = content
    }
    
    @Binding var data: Data
    private let content: (Data.Element, Binding<Data.Element>) -> Content
    
    var body: some View {
        ForEach(data.indexed()) { row in
            if data.indices.contains(row.index) {
                AnyView(content(row.element, $data[row.index]))
            } else {
                AnyView(EmptyView())
            }
        }
    }
}
