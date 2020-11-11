//
//  FolderPicker.swift
//  Rede
//
//  Created by Marcus Rossel on 09.11.20.
//

import SwiftUI

struct FolderPicker: View {
    
    init(selection: Binding<Row<Folder>?>, excluded: Set<Row<Folder>> = []) {
        _selection = selection
        self.excluded = excluded
    }
    
    @StateObject private var storage: Storage = .shared
    
    @Binding private var selection: Row<Folder>?
    private let excluded: Set<Row<Folder>>
    
    var body: some View {
        List {
            Section(header: Text("Destination")) {
                ForEach(storage.folders.indexed()) { row in
                    if excluded.contains(row) { EmptyView() } else {
                        HStack {
                            Label {
                                Text(row.element.name)
                            } icon: {
                                Image(systemName: row.element.icon.name)
                                    .foregroundColor(row.element.icon.color)
                            }
                            
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { selection = row }
                        .listRowBackground(
                            row == selection ? Color(.tertiarySystemBackground) : .clear
                        )
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}
