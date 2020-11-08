//
//  FolderEditor.swift
//  Rede
//
//  Created by Marcus Rossel on 29.09.20.
//

import SwiftUI
import DataField

struct FolderEditor: View {
    
    @StateObject private var storage = Storage.shared
    @Binding var folder: Folder
    @State private var textIsValid = true
    
    var body: some View {
        Label {
            DataField("Folder Name", data: $folder.name) { text in
                storage.isValid(folderName: text, for: folder)
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
        
        @State var folder = Folder.previewData[0]
        
        var body: some View {
            FolderEditor(folder: $folder)
                .padding()
                .onAppear { Storage.shared.folders = Folder.previewData }
        }
    }
}
