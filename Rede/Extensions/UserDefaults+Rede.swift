//
//  UserDefaults+Rede.swift
//  Rede
//
//  Created by Marcus Rossel on 29.08.20.
//

import Foundation

extension UserDefaults {
    static var rede: UserDefaults? { UserDefaults(suiteName: "group.com.marcusrossel.Rede.share") }
}
