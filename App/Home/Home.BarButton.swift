//
//  Home.BarButton.swift
//  Rede / App
//
//  Created by Marcus Rossel on 22.11.20.
//

import SwiftUI

extension Home {
    
    struct BarButton: View {
        
        @StateObject private var storage: Storage = .shared
        var sheet: Binding<Sheet?>
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
                Menu {
                    Button {
                        let newFolder = Folder(name: "")
                        storage.folders.insert(newFolder, at: 0)
                        sheet.wrappedValue = .new(folder: $storage.folders[permanent: newFolder.id])
                    } label: {
                        Label("New Folder", systemImage: "folder.fill.badge.plus")
                    }

                    if storage.folders.count > 1 {
                        Button {
                            withAnimation { editMode?.wrappedValue = .active }
                        } label: {
                            Label("Reorder Folders", systemImage: "rectangle.arrowtriangle.2.outward")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                }
            }
        }
    }
}

