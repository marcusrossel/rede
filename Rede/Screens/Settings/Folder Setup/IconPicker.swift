//
//  IconPicker.swift
//  Rede
//
//  Created by Marcus Rossel on 02.09.20.
//

import SwiftUI

struct IconPicker: View {
    
    @Binding var icon: (name: String, color: Color)
    
    @State private var showPicker = false
    
    @ScaledMetric private var tileSize: CGFloat = 55
    private let columns = [GridItem(.adaptive(minimum: 55))]
    
    var body: some View {
        Image(systemName: icon.name)
            .foregroundColor(icon.color)
            .sheet(isPresented: $showPicker) {
                VStack(spacing: 0) {
                    HStack {
                        ColorPicker("Icon Color", selection: $icon.color, supportsOpacity: false)
                            .labelsHidden()
                            .padding()
    
                        Spacer()
                        
                        HStack(alignment: .firstTextBaseline) {
                            Text("Choose Icon")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button(action: { showPicker = false }) {
                                Text("Close")
                                    .font(.headline)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    .padding([.leading, .trailing])
                    
                    Divider()
                    
                    ScrollView {
                        // For padding.
                        Color.clear
                        
                        LazyVGrid(columns: columns) {
                            ForEach(SFSymbols.all, id: \.self) { symbol in
                                ZStack {
                                    Circle()
                                        .fill(Color(.secondarySystemBackground))
                                        .frame(width: tileSize, height: tileSize)
                                    
                                    Image(systemName: symbol)
                                        .font(.system(size: 22))
                                        .foregroundColor(icon.color)
                                }
                                .onTapGesture {
                                    icon.name = symbol
                                    showPicker = false
                                }
                            }
                        }
                        .lineSpacing(16)
                        
                        // For padding.
                        Color.clear
                    }
                    .padding([.leading, .trailing])
                }
                .ignoresSafeArea([.container], edges: .bottom)
            }
            .onTapGesture {
                showPicker = true
            }
    }
}

struct IconPicker_Previews: PreviewProvider {
    
    static var previews: some View {
        StatefulPreview()
    }
    
    /// A `View` that is used for the preview, as `@State` doesn't work on non-`View`s.
    struct StatefulPreview: View {
        
        @State var icon = Folder.previewData[0].icon
        
        var body: some View {
            IconPicker(icon: $icon)
        }
    }
}
