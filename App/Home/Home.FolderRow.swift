//
//  Home.FolderRow.swift
//  Rede / App
//
//  Created by Marcus Rossel on 08.11.20.
//

import SwiftUI

extension Home {
    
    struct FolderRow: View {
        
        @Binding var folder: Folder
        
        var body: some View {
            NavigationLink(destination: FolderDetail(folder: $folder)) {
                HStack {
                    Label {
                        Text(folder.name)
                            .font(.headline)
                    } icon: {
                        Image(systemName: folder.icon.name)
                            .foregroundColor(folder.icon.color)
                            .font(.title3)
                    }
                    
                    Spacer()
                    
                    let unreadBookmarks = folder.bookmarks.filter { $0.readDate == nil }.count
                    if unreadBookmarks != 0 {
                        Text("\(unreadBookmarks)")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}
