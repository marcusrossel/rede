//
//  Home.FolderRow.swift
//  Rede / App
//
//  Created by Marcus Rossel on 08.11.20.
//

import SwiftUI

extension Home {
    
    struct FolderRow: View {
        
        let row: Row<Folder>
        
        var body: some View {
            NavigationLink(destination: FolderDetail(row: row)) {
                HStack {
                    Label {
                        Text(row.element.name)
                    } icon: {
                        Image(systemName: row.element.icon.name)
                            .foregroundColor(row.element.icon.color)
                    }
                    
                    Spacer()
                    
                    let unreadBookmarks = row.element.bookmarks.filter { $0.readDate == nil }.count
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
