//
//  FolderMerger.swift
//  Rede
//
//  Created by Marcus Rossel on 09.11.20.
//

import SwiftUI

struct FolderMerger: View {
    
    @StateObject private var storage: Storage = .shared
    
    let source: Row<Folder>
    @State private var destination: Row<Folder>?
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Merging a folder adds all of its bookmarks to the end of a selected folder. This will cause the source folder to be deleted!")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding([.leading, .trailing, .top])
                
                FolderPicker(selection: $destination, excluded: [source])
            }
            .navigationBarTitle(Text("Merge \"\(source.element.name)\""), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    },
                trailing:
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        guard let destination = destination else { return }
                        storage.folders[destination.index].bookmarks += storage.folders[source.index].bookmarks
                            storage.folders.remove(at: source.index)
                    } label: {
                        Text("Merge")
                    }
                    .disabled(destination == nil)
            )
        }
    }
}
