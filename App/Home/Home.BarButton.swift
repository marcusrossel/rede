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
        @Binding var sheet: Sheet?
        var editMode: Binding<EditMode>?
        
        var onNewFolder: () -> Void
        
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
                        onNewFolder()
                    } label: {
                        Label("New Folder", systemImage: "folder.fill.badge.plus")
                            .font(.headline)
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

