//
//  Home.NoFolders.swift
//  Rede / App
//
//  Created by Marcus Rossel on 09.11.20.
//

import SwiftUI

extension Home {

    struct NoFolders: View {
        
        let onTapGesture: () -> Void
        
        var body: some View {
            VStack(spacing: 12) {
                Button(action: onTapGesture) {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 45))
                        .foregroundColor(Color(#colorLiteral(red: 0.3895070553, green: 0.7931495309, blue: 0.4028683305, alpha: 1)))
                        .overlay(
                            Image(systemName: "plus")
                                .font(Font.system(size: 20).bold())
                                .padding(.top, 15)
                                .foregroundColor(Color(.systemBackground))
                        )
                }
                
                Text("No folders yet?\nTry adding one!")
                    .fontWeight(.bold)
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(30)
        }
    }
}
