//
//  URL+LosslessStringConvertible.swift
//  Rede / Common
//
//  Created by Marcus Rossel on 09.11.20.
//

import Foundation

extension URL: LosslessStringConvertible {
    
    public init?(_ string: String) {
        // https://stackoverflow.com/a/49072718/3208492
        guard
            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue),
            let match = detector.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)),
            match.range.length == string.utf16.count,
            let url = URL(string: string)
        else { return nil }
        
        self = url
    }    
}
