//
//  FolderDetail.BookmarkRow.swift
//  Rede
//
//  Created by Marcus Rossel on 08.11.20.
//

import SwiftUI

extension FolderDetail {
    
    struct BookmarkRow: View {
        
        let bookmark: Bookmark
        
        // `Link` can't open *any* URL, so this is a cheap attempt at making it do so anyway.
        private var openableURL: URL {
            if bookmark.url.absoluteString.hasPrefix("https://") || bookmark.url.absoluteString.hasPrefix("http://") {
                return bookmark.url
            } else {
                return URL(string: "https://" + bookmark.url.absoluteString)!
            }
        }
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Spacer()
                    
                    Link(bookmark.title, destination: openableURL)
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
                }
                
                Group {
                    Image(systemName: "safari")
                    Image(systemName: "chevron.forward")
                }
                .foregroundColor(Color(.tertiaryLabel))
            }
        }
    }
}
