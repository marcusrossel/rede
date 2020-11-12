//
//  Storage.swift
//  Rede / Common
//
//  Created by Marcus Rossel on 16.10.20.
//

import SwiftUI

// MARK: Storage

final class Storage: ObservableObject {

    @Published var folders: [Folder] = []
    
    private init() { }
    
    static let shared = Storage()
    
    static let directory = FileManager.default
        .containerURL(forSecurityApplicationGroupIdentifier: "group.com.marcusrossel.Rede.share")!
    
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    func load() {
        if let data = try? String(contentsOf: File.folders.path).data(using: .utf8) {
            if let container = try? Self.decoder.decode(Container<[Folder]>.self, from: data) {
                folders = container.data
            } else {
                fatalError("Corrupted data.")
            }
        }
    }
    
    func save() throws {
        let tasks: [File: Data] = try [
            .folders: Self.encoder.encode(Container(version: .one, data: folders))
        ]
        
        for (file, data) in tasks {
            try String(data: data, encoding: .utf8)?
                .write(to: file.path, atomically: true, encoding: .utf8)
        }
    }
}

// MARK: Accessors

prefix operator §

extension Folder {
    
    static prefix func § (folder: Folder) -> Binding<Folder> {
        let storage = Storage.shared
        
        return Binding {
            storage.folders.first { $0.id == folder.id } ?? folder
        } set: { newValue in
            guard let index = storage.folders.firstIndex(where: { $0.id == folder.id }) else { return }
            storage.folders[index] = newValue
        }
    }
}

extension Folder.ID {

    static prefix func § (folderID: Folder.ID) -> Binding<Folder>? {
        let storage = Storage.shared
        guard let fallback = storage.folders.first(where: { $0.id == folderID }) else { return nil }
        
        return Binding {
            storage.folders.first { $0.id == folderID } ?? fallback
        } set: { newValue in
            guard let index = storage.folders.firstIndex(where: { $0.id == folderID }) else { return }
            storage.folders[index] = newValue
        }
    }
}

extension Bookmark {
    
    static prefix func § (bookmark: Bookmark) -> Binding<Bookmark>? {
        return Binding {
            guard
                let folder = §bookmark.folderID,
                let index = folder.wrappedValue.bookmarks.firstIndex(where: { $0.id == bookmark.id })
            else { return bookmark }
            
            return folder.wrappedValue.bookmarks[index]
        } set: { newValue in
            guard
                let folder = §bookmark.folderID,
                let index = folder.wrappedValue.bookmarks.firstIndex(where: { $0.id == bookmark.id })
            else { return }
            
            folder.wrappedValue.bookmarks[index] = newValue
        }
    }
}

// MARK: File

fileprivate enum File: String, Hashable {
    
    case folders

    var path: URL { Storage.directory.appendingPathComponent("\(rawValue).json") }
}

// MARK: Container

fileprivate struct Container<T: Codable>: Codable {
    let version: Version
    let data: T
}

// MARK: Version

fileprivate enum Version: String, Codable {
    case one = "1"
}
