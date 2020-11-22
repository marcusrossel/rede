//
//  BookmarkEditor.ReadButton.swift
//  Rede / App
//
//  Created by Marcus Rossel on 12.11.20.
//

import SwiftUI

extension BookmarkEditor {
    
    struct ReadButton: View {
        
        @Binding var readDate: Date?
        @State private var rotation: Angle = .degrees(0)
        
        var body: some View {
            ZStack {
                Button {
                    withAnimation {
                        rotation.degrees += 180
                        readDate = (readDate == nil) ? Date() : nil
                    }
                } label: {
                    Circle()
                        .foregroundColor(Color(.secondarySystemBackground))
                        .frame(maxWidth: 120, maxHeight: 120)
                }
                
                VStack(spacing: 10) {
                    Image(systemName: "book\(readDate == nil ? "" : ".fill")")
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 0.2635219395, blue: 0.2254285514, alpha: 1)))
                        .font(.system(size: 30))
                        .rotation3DEffect(rotation, axis: (x: 0, y: 1, z: 0))

                    Text("Read")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .disabled(true)
            }
        }
    }
}
