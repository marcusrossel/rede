//
//  BookmarkReader.Blur.swift
//  Rede
//
//  Created by Marcus Rossel on 01.12.20.
//

import SwiftUI

extension BookmarkReader {

    struct Blur: UIViewRepresentable {
        
        var style: UIBlurEffect.Style = .systemMaterial
        
        func makeUIView(context: Context) -> UIVisualEffectView {
            UIVisualEffectView(effect: UIBlurEffect(style: style))
        }
        
        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
            uiView.effect = UIBlurEffect(style: style)
        }
    }
}
