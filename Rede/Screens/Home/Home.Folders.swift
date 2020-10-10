//
//  Home.Folders.swift
//  Rede
//
//  Created by Marcus Rossel on 23.09.20.
//

import SwiftUI

// MARK: - Home Folders
 
extension Home {
    
    struct Folders: View {
        
        /*Keep this a binding, so that this view can also be edited using context menus.*/
        @Binding var folders: [Folder]
        
        private func index(for folder: Folder) -> Int {
            if let folderIndex = folders.firstIndex(of: folder) {
                return folderIndex
            } else {
                fatalError("Folder '\(folder.name)' is not in the shelf.")
            }
        }
        
        var body: some View {
            ForEach(folders) { folder in
                let destination = FolderView(folder: $folders[index(for: folder)])
                
                NavigationLink(destination: destination) {
                    Row(folder: folder)
                }
            }
        }
    }
}

// MARK: - Row

extension Home.Folders {
    
    struct Row: View {
        
        let folder: Folder
        
        var body: some View {
            HStack {
                Label(
                    title: { Text(folder.name) },
                    icon: {
                        Image(systemName: folder.icon.name)
                            .foregroundColor(folder.icon.color)
                    }
                )
                
                Spacer()

                Text("\(folder.unreadBookmarks.count)")
                    .font(.footnote)
            }
        }
    }
}

// MARK: - Previews

struct HomeFolders_Previews: PreviewProvider {
    
    static var previews: some View {
        StatefulPreview()
            
    }
    
    /// A `View` that is used for the preview, as `@State` doesn't work on non-`View`s.
    struct StatefulPreview: View {
        
        @State private var folders = Folder.previewData
        
        var body: some View {
            NavigationView {
                List {
                    Home.Folders(folders: $folders)
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
    }
}

