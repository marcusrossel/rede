//
//  Home.ContextMenu.swift
//  Rede / App
//
//  Created by Marcus Rossel on 22.11.20.
//

import SwiftUI

extension Home {
    
    struct ContextMenu: View {
        
        @StateObject private var storage: Storage = .shared
        @Binding var folder: Folder
        
        var editMode: Binding<EditMode>?
        @Binding var sheet: Sheet?
        @Binding var folderInDeletion: Folder?
        
        var body: some View {
            switch editMode?.wrappedValue {
            case .active:
                EmptyView()
            default:
                Button {
                    sheet = .edit(folder: $folder)
                } label: {
                    Text("Edit")
                    Image(systemName: "slider.horizontal.3")
                }
                
                Button {
                    if folder.bookmarks.isEmpty {
                        storage.folders.remove(id: folder.id)
                    } else {
                        folderInDeletion = folder
                    }
                } label: {
                    Text("Delete")
                    Image(systemName: "minus.circle.fill")
                }
            }
        }
    }
}

