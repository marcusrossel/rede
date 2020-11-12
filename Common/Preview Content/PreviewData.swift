//
//  PreviewData.swift
//  Rede / Common
//
//  Created by Marcus Rossel on 22.09.20.
//

import SwiftUI

enum PreviewData {
    
    // MARK: URL
    
    static let urls: [URL] = [
        URL(string: "https://swift.org")!,
        URL(string: "https://tech.guardsquare.com/posts/swift-native-method-swizzling/")!,
        URL(string: "http://literatejava.com/exceptions/")!,
        URL(string: "http://bostonreview.net/philosophy-religion/")!,
        URL(string: "https://engineering.shopify.com/blogs/engineering/what-is-nix")!,
        URL(string: "http://marcusrossel.com/2020-07-13/counting-complexity")!,
        URL(string: "https://www.youtube.com/watch?v=7pSqk-XV2QM")!,
        URL(string: "https://markmap.js.org")!,
        URL(string: "http://marcusrossel.com")!
    ]
    
    // MARK: Bookmarks
    
    private static let hour: Double = 60 * 60
    private static let day:  Double = 24 * hour
    
    static let bookmarks: [Bookmark] = [
        Bookmark(
            title: "Swift.org",
            url: urls[0]
        ),
        Bookmark(
            title: "Native Method Swizzling",
            url: urls[1],
            additionDate: Date().addingTimeInterval(-3 * hour),
            readDate: Date()
        ),
        Bookmark(
            title: "Exceptions",
            url: urls[2],
            additionDate: Date().addingTimeInterval(-5 * day)
        ),
        Bookmark(
            title: "Philosophy & Religion",
            url: urls[3],
            readDate: Date()
        ),
        Bookmark(
            title: "What is Nix?",
            url: urls[4],
            additionDate: Date().addingTimeInterval(-100 * day),
            readDate: Date().addingTimeInterval(-50 * day)
        ),
        Bookmark(
            title: "The Complexity of Counting",
            url: urls[5],
            additionDate: Date().addingTimeInterval(-1 * hour),
            readDate: Date().addingTimeInterval(-1 * hour)
        ),
        Bookmark(
            title: "How Kodak Detected the Atomic Bomb",
            url: urls[6]
        ),
        Bookmark(
            title: "markmap-lib",
            url: urls[7],
            additionDate: Date().addingTimeInterval(-2 * day)
        ),
        Bookmark(
            title: "marcus'",
            url: urls[8],
            additionDate: Date().addingTimeInterval(-1 * day)
        )
    ]
    
    // MARK: Folders
    
    static let previewData: [Folder] = [
        Folder(
            name: "Empty"
        ),
        Folder(
            name: "Programming",
            bookmarks: Array(bookmarks[0...2]),
            icon: Icon(name: "command", color: .green)
        ),
        Folder(
            name: "Social",
            bookmarks: Array(bookmarks[3...3]),
            icon: Icon(name: "person.fill", color: .yellow)
        ),
        Folder(
            name: "Math",
            bookmarks: Array(bookmarks[4...5]),
            sorting: .byTitle,
            icon: Icon(name: "number", color: .red)
        ),
        Folder(
            name: "Videos",
            bookmarks: Array(bookmarks[6...6]),
            sorting: .byDate,
            icon: Icon(name: "tropicalstorm", color: .blue)
        ),
        Folder(
            name: "Tools",
            bookmarks: Array(bookmarks[7...8]),
            sorting: .byDate,
            icon: Icon(name: "hammer.fill", color: .white)
        )
    ]
}
