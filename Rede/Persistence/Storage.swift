//
//  Storage.swift
//  Rede
//
//  Created by Marcus Rossel on 24.09.20.
//

import Foundation

// MARK: - Storage

protocol Storage: NSObject {
    
    associatedtype Key: RawRepresentable, CaseIterable where Key.RawValue == String
    
    func key(for path: PartialKeyPath<Self>) -> Key
    
    func set(_ data: Data, forKey: Key)
    
    init()
}

extension Storage {
    
    var defaultsSuite: UserDefaults { UserDefaults.rede! }
    
    func didSet<Value: Encodable>(_ value: Value, for path: KeyPath<Self, Value>) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        defaultsSuite.set(data, forKey: key(for: path).rawValue)
    }
    
    func set<Value: Decodable>(_ path: ReferenceWritableKeyPath<Self, Value>, from data: Data) {
        guard let value = try? JSONDecoder().decode(Value.self, from: data) else { return }
        self[keyPath: path] = value
    }
    
    func `init`<Value: Decodable>(_ path: ReferenceWritableKeyPath<Self, Value>) {
        defaultsSuite.addObserver(self, forKeyPath: key(for: path).rawValue, options: .new, context: nil)
        
        guard let data = defaultsSuite.data(forKey: key(for: path).rawValue) else { return }
        set(path, from: data)
    }
    
    #warning("Make sure this is called.")
    func observeValue(forKeyPath keyPath: String?, change: [NSKeyValueChangeKey : Any]?) {
        guard
            let keyPath = keyPath,
            let newValue = change?[.newKey] as? Data,
            let key = Key(rawValue: keyPath)
        else { return }
        
        set(newValue, forKey: key)
    }
}
