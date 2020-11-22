//
//  BookmarkEditor.FavoriteButton.swift
//  Rede / App
//
//  Created by Marcus Rossel on 12.11.20.
//

import SwiftUI

extension BookmarkEditor {
    
    struct FavoriteButton: View {
        
        @Binding var isFavorite: Bool
        @State private var rotation: Angle = .degrees(0)
        
        var body: some View {
            ZStack {
                Button {
                    withAnimation {
                        rotation.degrees += 72
                        isFavorite.toggle()
                    }
                } label: {
                    Circle()
                        .foregroundColor(Color(.secondarySystemBackground))
                        .frame(maxWidth: 120, maxHeight: 120)
                }
                
                VStack(spacing: 10) {
                    Image(systemName: "star\(isFavorite ? ".fill" : "")")
                        .rotationEffect(rotation)
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 0.8410827518, blue: 0.05768922716, alpha: 1)))
                        .font(.system(size: 30))

                    Text("Favorite")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
