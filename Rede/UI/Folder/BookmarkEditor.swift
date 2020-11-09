//
//  BookmarkEditor.swift
//  Rede
//
//  Created by Marcus Rossel on 09.11.20.
//

import SwiftUI
import DataField

struct BookmarkEditor: View {
    
    init(bookmark: Binding<Bookmark>) {
        let model = Model(bookmark: bookmark)
        _model = StateObject(wrappedValue: model)
    }
    
    @StateObject private var model: Model
    
    @State private var urlIsValid = true
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Bookmark Title", text: $model.bookmark.title)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding()
                
                HStack {
                    DataField("URL", data: $model.bookmark.url, invalidText: { invalidText in
                        urlIsValid = invalidText == nil
                    })
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(8)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding()
                    
                    if !urlIsValid {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .renderingMode(.original)
                            .padding(.trailing)
                    }
                }
                
                HStack {
                    Button {
                        model.bookmark.isFavorite.toggle()
                    } label: {
                        Image(systemName: "star\(model.bookmark.isFavorite ? ".fill" : "")")
                            .renderingMode(model.bookmark.isFavorite ? .original : .template)
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 0.8410827518, blue: 0.05768922716, alpha: 1)))
                            .font(.system(size: 30))
                    }
                    
                    Button {
                        model.bookmark.readDate = (model.bookmark.readDate == nil) ? Date() : nil
                    } label: {
                        Image(systemName: "bookmark\(model.bookmark.readDate == nil ? "" : ".fill")")
                            .renderingMode(model.bookmark.readDate == nil ? .template : .original)
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 0.2635219395, blue: 0.2254285514, alpha: 1)))
                            .font(.system(size: 30))
                    }
                }
                
                // FolderPicker(selection: <#T##Binding<Row<Folder>?>#>, excluded: <#T##Set<Row<Folder>>#>)
            }
            .navigationBarTitle("Edit Bookmark", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button {
                        model.onCompletion(.cancel, presentationMode)
                    } label: {
                        Text("Cancel")
                    },
                trailing:
                    Button {
                        model.onCompletion(.done, presentationMode)
                    } label: {
                        Text("Done")
                    }
                    .disabled(model.bookmark.title.isEmpty)
            )
        }
    }
    
}

// MARK: View Model

extension BookmarkEditor {
    
    fileprivate final class Model: ObservableObject {
        
        enum Completion { case done, cancel }
    
        @Binding private var original: Bookmark
        @Published var bookmark: Bookmark
        
        private(set) var onCompletion: (Completion, Binding<PresentationMode>) -> Void = { _, _ in }
        
        init(bookmark: Binding<Bookmark>) {
            _original = bookmark
            self.bookmark = bookmark.wrappedValue
            
            self.onCompletion = { [weak self] completion, presentationMode in
                if let self = self, case .done = completion { bookmark.wrappedValue = self.bookmark }
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
