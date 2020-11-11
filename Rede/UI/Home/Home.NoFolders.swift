//
//  Home.NoFolders.swift
//  Rede
//
//  Created by Marcus Rossel on 09.11.20.
//

import SwiftUI

extension Home {

    struct NoFolders: View {
        
        let onTapGesture: () -> Void
        
        var body: some View {
            HStack {
                Text("No folders yet? Try adding one!")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Button(action: onTapGesture) {
                    Image(systemName: "folder.fill.badge.plus")
                        .renderingMode(.original)
                }
            }
            .font(.title3)
            .multilineTextAlignment(.center)
            .padding()
        }
    }
}
