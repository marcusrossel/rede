//
//  FolderEditor.swift
//  Rede
//
//  Created by Marcus Rossel on 29.09.20.
//

import SwiftUI
import DataField

struct FolderEditor: View {
    
    @Binding var folder: Folder
    
    @EnvironmentObject private var shelf: Shelf
    @State private var textIsValid = true
    
    var body: some View {
        Label {
            DataField("Folder Name", data: $folder.name) { text in
                !text.isEmpty
            } invalidText: { text in
                textIsValid = (text == nil)
            }
            .padding(5)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.secondary, lineWidth: 0.2)
            )
            
            if !textIsValid {
                Image(systemName: "xmark.octagon.fill")
                    .renderingMode(.original)
            }
        } icon: {
            IconPicker(icon: $folder.icon)
        }
    }
}

struct FolderEditor_Previews: PreviewProvider {
    
    static var previews: some View {
        StatefulPreview()
    }
    
    /// A `View` that is used for the preview, as `@State` doesn't work on non-`View`s.
    struct StatefulPreview: View {
        
        @StateObject private var shelf = Shelf.previewData
        
        var body: some View {
            FolderEditor(folder: $shelf.folders[0])
                .environmentObject(shelf)
        }
    }
}
