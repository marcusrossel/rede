//
//  Home.swift
//  Rede
//
//  Created by Marcus Rossel on 29.08.20.
//

import SwiftUI
import Combine

struct Home: View {
    
    @EnvironmentObject var shelf: Shelf
    
    var body: some View {
        List {
            Section {
                Folders(folders: $shelf.folders)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Folders")
        .navigationBarItems(trailing:
            NavigationLink(destination:
                SettingsView()/*SwiftUI bug*/.environmentObject(shelf)
            ) {
                Image(systemName: "gear")
            }
        )
    }
}

// MARK: - Previews

struct Home_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            Home()
                .environmentObject(Shelf.previewData)
        }
    }
}

/*@AppStorage("allowUncategorizedBookmarks", store: .rede)
private var allowUncategorizedBookmarks = true

@AppStorage("showAllBookmarks", store: .rede)
private var showAllBookmarks = true*/

/*var body: some View {
    ScrollView {
        List {
            Section {
                ForEach(shelf.folders) { folder in
                    let taggedBookmarks = $shelf.folders.map { folder in
                        folder.bookmarks.tagged(with: folder)
                    }
                    
                    let destination = BookmarkList(
                        bookmarks: taggedBookmarks,
                        sorting: binding(folder, \.sorting),
                        title: folder.name
                    ).onFolderChange { bookmark, newFolder in
                        if let origin = folders.firstIndex(where: { $0.name = bookmark.tag.name }) {
                            folders[origin].bookmarks.remove(bookmark)
                        } else {
                            uncategorized.bookmarks.remove(bookmark)
                        }
                    }
                    
                    
                    
                    /*let destination = BookmarkList(
                     bookmarks: binding(folder, \.bookmarks),
                     sorting: binding(folder, \.sorting),
                     title: folder.name
                     )
                     
                     NavigationLink(destination: destination) {
                     FolderCell(folder: .constant(folder))
                     }
                     */
                }
            }
            
            if showAllBookmarks {
                let allFolder = Folder(
                    name: "All Bookmarks",
                    bookmarks: folders.flatMap(\.bookmarks) + uncategorized.bookmarks,
                    sorting: .byDate,
                    icon: (name: "tray.full", color: .white)
                )
                
                let destination: BookmarkList = fatalError()
                // let destination = BookmarkList(bookmarks: allFolder.bookmarks, title: allFolder.name)
                
                NavigationLink(destination: destination) {
                    FolderCell(folder: .constant(allFolder))
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Folders")
        .navigationBarItems(trailing:
                                NavigationLink(destination: SettingsView()) { Image(systemName: "gear") }
        )
        
        /*if allowUncategorizedBookmarks {
            VStack {
                Text("Uncategorized")
                
                let taggedBookmarks = Binding<[Bookmark.Tagged]>(
                    get: { uncategorized.bookmarks.map { $0.tagged(with: uncategorized) } },
                    set: { uncategorized.bookmarks = $0.map(\.bookmark) }
                )
                
                let sorting = Binding<Bookmark.Sorting>(
                    get: { uncategorized.sorting },
                    set: { uncategorized.sorting = $0 }
                )
                
                BookmarkList(
                    bookmarks: taggedBookmarks,
                    sorting: sorting,
                    title: "Uncategorized"
                ).onFolderChange { bookmark, newFolder in
                    let bookmarkIndex = uncategorized.firstIndex(of: folder)!
                    uncategorized.bookmarks.remove(at: index)
                    
                    if newFolder.isUncategorized {
                        uncategorized.bookmarks.insert(bookmark, at: 0)
                    } else {
                        let folderIndex = folders.firstIndex(of: folder)
                        folders[folderIndex].insert(bookmark, at: 0)
                    }
                }
            }
        }
    }*/
}*/
