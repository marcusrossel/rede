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
                    } icon: {
                        Image(systemName: folder.icon.name)
                            .foregroundColor(folder.icon.color)
                    }
                    
                    Spacer()
                    
                    let unreadBookmarks = folder.bookmarks.filter { $0.readDate == nil }.count
                    if unreadBookmarks != 0 {
                        Text("\(unreadBookmarks)")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}
