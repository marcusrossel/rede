//
//  BookmarkEditor.URLField.swift
//  Rede / Common
//
//  Created by Marcus Rossel on 12.11.20.
//

import SwiftUI
import DataField

extension BookmarkEditor {
    
    struct URLField: View {
        
        @Binding var url: URL
        @State private var textIsValid = true
        
        var body: some View {
            HStack {
                DataField("URL", initialData: url, sinkContinuously: true) { text in
                    URL(string: text)
                } dataToText: { url in
                    url?.absoluteString ?? ""
                } sink: { validURL in
                    url = validURL
                } invalidText: { invalidText in
                    textIsValid = invalidText == nil
                }
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                
                if !textIsValid {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .renderingMode(.original)
                }
            }
        }
    }
}
