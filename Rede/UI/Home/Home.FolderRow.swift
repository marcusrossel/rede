//
//  Home.FolderRow.swift
//  Rede
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
                    
                    if row.element.bookmarks.count != 0 {
                        Text("\(row.element.bookmarks.count)")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}
