//
//  FolderDetail.BookmarkRow.swift
//  Rede / App
//
//  Created by Marcus Rossel on 08.11.20.
//

import SwiftUI

extension FolderDetail {
    
    struct BookmarkRow: View {
        
        @Binding var bookmark: Bookmark
        
        var body: some View {
            NavigationLink(destination: BookmarkReader(bookmark: $bookmark)) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Spacer()
                        
                        Text(bookmark.title)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text(bookmark.url.host ?? bookmark.url.description)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }

                    Spacer()
                    
                    if bookmark.isFavorite {
                        Image(systemName: "star.fill")
                            .renderingMode(.original)
                            .font(.footnote)
                            .transition(.scale)
                    }
                }
            }
        }
    }
}
