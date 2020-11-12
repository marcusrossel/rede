//
//  FolderPicker.swift
//  Rede / Common
//
//  Created by Marcus Rossel on 09.11.20.
//

import SwiftUI

struct FolderPicker: View {
    
    init(title: String, selection: Binding<Folder.ID?>, excluded: Set<Folder.ID> = []) {
        _selection = selection
        self.title = title
        self.excluded = excluded
    }
    
    @StateObject private var storage: Storage = .shared
    
    @Binding private var selection: Folder.ID?
    private let title: String
    private let excluded: Set<Folder.ID>
    
    var body: some View {
        List {
            Section(header: Text(title)) {
                ForEach(storage.folders) { folder in
                    if excluded.contains(folder.id) { EmptyView() } else {
                        HStack {
                            Label {
                                Text(folder.name)
                            } icon: {
                                Image(systemName: folder.icon.name)
                                    .foregroundColor(folder.icon.color)
                            }
                            
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selection = folder.id
                        }
                        .listRowBackground(
                            folder.id == selection ? Color(.tertiarySystemBackground) : .clear
                        )
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}
