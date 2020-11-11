//
//  FolderPicker.swift
//  Rede / App
//
//  Created by Marcus Rossel on 09.11.20.
//

import SwiftUI

struct FolderPicker: View {
    
    init(title: String, selection: Binding<Row<Folder>>) {
        _selection = Binding<Row<Folder>?> {
            selection.wrappedValue
        } set: {
            // The folder picker never writes `nil` values to the binding, so this is ok.
            guard let newValue = $0 else { fatalError("Internal inconsistency in '\(Self.self)'") }
            selection.wrappedValue = newValue
        }
        
        self.title = title
        self.excluded = []
    }
    
    init(title: String, selection: Binding<Row<Folder>?>, excluded: Set<Row<Folder>> = []) {
        _selection = selection
        self.title = title
        self.excluded = excluded
    }
    
    @StateObject private var storage: Storage = .shared
    
    @Binding private var selection: Row<Folder>?
    private let title: String
    private let excluded: Set<Row<Folder>>
    
    var body: some View {
        List {
            Section(header: Text(title)) {
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
