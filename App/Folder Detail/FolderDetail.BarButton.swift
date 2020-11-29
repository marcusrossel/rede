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
        var editMode: Binding<EditMode>?
        
        var body: some View {
            switch editMode?.wrappedValue {
            case .active:
                Button("Done") {
                    withAnimation {
                        editMode?.wrappedValue = .inactive
                    }
                }
            default:
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
