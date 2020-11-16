//
//  FolderDetail.BarButton.swift
//  Rede / App
//
//  Created by Marcus Rossel on 16.11.20.
//

import SwiftUI

extension FolderDetail {
    
    struct BarButton: View {
        
        @Binding var folder: Folder
        
        // Setting the edit mode from a subview does not currently set it in the parent. This is a
        // workaround.
        @Binding var editMode: EditMode?
        
        var body: some View {
            if (editMode != .inactive) {
                Button("Done") { withAnimation { editMode = .inactive } }
            } else {
                Picker(selection: $folder.sorting, label: Image(systemName: "arrow.up.arrow.down.circle.fill")) {
                    ForEach(Folder.Sorting.allCases) { sorting in
                        Label(sorting.rawValue, systemImage: sorting.iconName)
                            .tag(sorting)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
    }
}
