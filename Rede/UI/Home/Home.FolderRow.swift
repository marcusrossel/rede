//
//  Home.FolderRow.swift
//  Rede
//
//  Created by Marcus Rossel on 08.11.20.
//

import SwiftUI

extension Home {
    
    struct FolderRow: View {
        
        @Binding var folder: Folder
        
        var body: some View {
            NavigationLink(destination: FolderDetail(_folder: $folder)) {
                HStack {
                    Label {
                        Text(folder.name)
                    } icon: {
                        Image(systemName: folder.icon.name)
                            .foregroundColor(folder.icon.color)
                    }
                    
                    Spacer()
                    
                    if folder.bookmarks.count != 0 {
                        Text("\(folder.bookmarks.count)")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}
