//
//  Home.FolderMerger.swift
//  Rede / App
//
//  Created by Marcus Rossel on 09.11.20.
//

import SwiftUI

extension Home {

    struct FolderMerger: View {
        
        @StateObject private var storage: Storage = .shared
        
        @Binding var source: Folder
        @State private var destinationID: Folder.ID?
        
        @Environment(\.presentationMode) private var presentationMode
        
        var body: some View {
            NavigationView {
                VStack {
                    Text("Merging a folder adds all of its bookmarks to the end of a selected folder. This will cause the source folder to be deleted!")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding([.leading, .trailing, .top])
                    
                    FolderPicker(title: "Destination", selection: $destinationID, excluded: [source.id])
                }
                .navigationBarTitle(Text("Merge \"\(source.name)\""), displayMode: .inline)
                .navigationBarItems(
                    leading:
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        },
                    trailing:
                        Button("Merge") {
                            presentationMode.wrappedValue.dismiss()
                            guard let destinationID = destinationID else { return }
                            
                            for id in source.bookmarks.map(\.id) {
                                source.bookmarks[permanent: id].folderID = destinationID
                            }
                            
                            storage.folders[permanent: destinationID].bookmarks += source.bookmarks
                            storage.backup[source.id] = source
                            storage.folders.remove(id: source.id)
                        }
                        .disabled(destinationID == nil)
                )
            }
        }
    }
}

