//
//  Label+Init.swift
//  Rede
//
//  Created by Marcus Rossel on 15.10.20.
//

import SwiftUI

extension Label where Title == Text, Icon == AnyView {
    
    init(title: String, icon: (name: String, color: Color)) {
        self.init(
            title: { Text(title) },
            icon: { AnyView(Image(systemName: icon.name).foregroundColor(icon.color)) }
        )
    }
}

