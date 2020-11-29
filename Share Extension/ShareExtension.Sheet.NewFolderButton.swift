//
//  ShareExtension.Sheet.NewFolderButton.swift
//  Rede / Share Extension
//
//  Created by Marcus Rossel on 29.11.20.
//

import SwiftUI

extension ShareExtension.Sheet {
    
    struct NewFolderButton: View {
        
        @Binding var folders: [Folder]
        @Binding var destination: Folder.ID?
        
        @State private var newFolder = Folder(name: "")
        @State private var sheetIsPresented = false
        
        var body: some View {
            Button {
                sheetIsPresented = true
            } label: {
                VStack(spacing: 10) {
                    Image(systemName: "folder.fill")
                        .foregroundColor(Color(#colorLiteral(red: 0.3895070553, green: 0.7931495309, blue: 0.4028683305, alpha: 1)))
                        .font(.system(size: 30))
                        .overlay(
                            Image(systemName: "plus")
                                .font(Font.system(size: 13).bold())
                                .padding(.top, 10)
                                .foregroundColor(Color(.systemBackground))
                        )
                        .frame(maxWidth: 40, maxHeight: 40)
                    
                    Text("New Folder")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                FolderEditor(folder: $newFolder) { action in
                    if case .acceptance = action {
                        folders.insert(newFolder, at: 0)
                        destination = newFolder.id
                    }
                    newFolder = Folder(name: "")
                }
            }
        }
    }
}
