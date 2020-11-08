//
//  Storage.swift
//  Rede
//
//  Created by Marcus Rossel on 16.10.20.
//

import SwiftUI

// MARK: Storage

final class Storage: ObservableObject {

    @Published var folders: [Folder] = []
    @Published var settings = Settings()
    
    private init() { load() }
    
    static let shared = Storage()
    
    static let directory = FileManager.default
        .containerURL(forSecurityApplicationGroupIdentifier: "group.com.marcusrossel.Rede.share")!
    
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    func isValid(folderName newName: String, for folder: Folder? = nil) -> Bool {
        !newName.isEmpty && folders.allSatisfy { $0.name != newName || folder?.name == newName }
    }
    
    func load() {
        if let data = try? String(contentsOf: File.folders.path).data(using: .utf8) {
            if let container = try? Self.decoder.decode(Container<[Folder]>.self, from: data) {
                folders = container.data
            } else {
                fatalError("Corrupted data.")
            }
        }
        
        if let data = try? String(contentsOf: File.settings.path).data(using: .utf8) {
            if let container = try? Self.decoder.decode(Container<Settings>.self, from: data) {
                settings = container.data
            } else {
                fatalError("Corrupted data.")
            }
        }
    }
    
    func save() throws {
        let tasks: [File: Data] = try [
            .folders: Self.encoder.encode(Container(version: .one, data: folders)),
            .settings: Self.encoder.encode(Container(version: .one, data: settings))
        ]
        
        for (file, data) in tasks {
            try String(data: data, encoding: .utf8)?
                .write(to: file.path, atomically: true, encoding: .utf8)
        }
    }
}

// MARK: File

fileprivate enum File: String, Hashable {
    
    case folders
    case settings
    
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
