//
//  Preview Data.swift
//  Rede
//
//  Created by Marcus Rossel on 22.09.20.
//

import SwiftUI

// MARK: URL

extension URL {
    
    static let previewData: [URL] = [
        URL(string: "https://swift.org")!,
        URL(string: "https://tech.guardsquare.com/posts/swift-native-method-swizzling/")!,
        URL(string: "http://literatejava.com/exceptions/")!,
        URL(string: "http://bostonreview.net/philosophy-religion/")!,
        URL(string: "https://engineering.shopify.com/blogs/engineering/what-is-nix")!,
        URL(string: "http://marcusrossel.com/2020-07-13/counting-complexity")!,
        URL(string: "https://www.youtube.com/watch?v=7pSqk-XV2QM")!,
        URL(string: "https://www.youtube.com/watch?v=pe83T9hISoY")!,
        URL(string: "https://markmap.js.org")!
    ]
}

// MARK: Bookmark

extension Bookmark {
    
    private static let hour: Double = 60 * 60
    private static let day:  Double = 24 * hour
    
    static let previewData: [Bookmark] = [
        Bookmark(
            title: "Swift.org",
            url: URL.previewData[0]
        ),
        Bookmark(
            title: "Native Method Swizzling",
            url: URL.previewData[1],
            additionDate: Date().addingTimeInterval(-3 * hour)
        ),
        Bookmark(
            title: "Exceptions",
            url: URL.previewData[2],
            additionDate: Date().addingTimeInterval(-5 * day)
        ),
        Bookmark(
            title: "Philosophy & Religion",
            url: URL.previewData[3]
        ),
        Bookmark(
            title: "What is Nix?",
            url: URL.previewData[4],
            additionDate: Date().addingTimeInterval(-100 * day)
        ),
        Bookmark(
            title: "The Complexity of Counting",
            url: URL.previewData[5],
            additionDate: Date().addingTimeInterval(-1 * hour)
        ),
        Bookmark(
            title: "How Kodak Detected the Atomic Bomb",
            url: URL.previewData[6]
        ),
        Bookmark(
            title: "Does Planet 9 Exist?",
            url: URL.previewData[7]
        ),
        Bookmark(
            title: "markmap-lib",
            url: URL.previewData[8],
            additionDate: Date().addingTimeInterval(-2 * day)
        )
    ]
}

// MARK: Folder

extension Folder {
    
    static let previewData: [Folder] = [
        Folder(
            name: "Empty"
        ),
        Folder(
            name: "Programming",
            bookmarks: .init(
                read: Array(Bookmark.previewData[0...0]),
                unread: Array(Bookmark.previewData[1...2])
            ),
            sorting: .manual,
            icon: Icon(name: "command", color: .green)
        ),
        Folder(
            name: "Social",
            bookmarks: .init(
                read: [],
                unread: Array(Bookmark.previewData[3...3])
            ),
            icon: Icon(name: "person.fill", color: .yellow)
        ),
        Folder(
            name: "Math",
            bookmarks: .init(
                read: Array(Bookmark.previewData[4...4]),
                unread: Array(Bookmark.previewData[5...5])
            ),
            sorting: .manual,
            icon: Icon(name: "number", color: .red)
        ),
        Folder(
            name: "Videos",
            bookmarks: .init(
                read: Array(Bookmark.previewData[6...7]),
                unread: []
            ),
            sorting: .manual,
            icon: Icon(name: "tropicalstorm", color: .blue)
        ),
        Folder(
            name: "Tools",
            bookmarks: .init(
                read: [],
                unread: Array(Bookmark.previewData[8...8])
            ),
            icon: Icon(name: "hammer.fill", color: .white)
        )
    ]
}