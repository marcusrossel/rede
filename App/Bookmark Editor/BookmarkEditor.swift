//
//  BookmarkEditor.swift
//  Rede / App
//
//  Created by Marcus Rossel on 09.11.20.
//

import SwiftUI

// MARK: Bookmark Editor

struct BookmarkEditor: View {
    
    init(title: String, bookmark: Binding<Bookmark>, onCompletion: ((Action) -> Void)? = nil) {
        let model = Model(bookmark: bookmark, onCompletion: onCompletion)
        _model = StateObject(wrappedValue: model)
        
        self.title = title
    }
    
    @StateObject private var model: Model
    
    private let title: String
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        EmptyView()
        NavigationView {
            VStack {
                TextField("Bookmark Title", text: $model.bookmark.title)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding([.leading, .trailing, .top])
                    .padding(.top, 8)
                
                URLField(url: $model.bookmark.url)
                    .font(.footnote)
                    .padding([.leading, .trailing], 32)
                    .padding(.bottom, 14)
                
                HStack {
                    Spacer()
                    FavoriteButton(isFavorite: $model.bookmark.isFavorite)
                    Spacer()
                    ReadButton(readDate: $model.bookmark.readDate)
                    Spacer()
                }
                
                FolderPicker(title: "Folder", selection: $model.bookmark.folderID)
            }
            .navigationBarTitle(title, displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        model.onCompletion(.rejection, presentationMode)
                    },
                trailing:
                    Button("Done") {
                        model.onCompletion(.acceptance, presentationMode)
                    }
                    .disabled(model.bookmark.title.isEmpty)
            )
        }
    }
}

// MARK: View Model

extension BookmarkEditor {
    
    fileprivate final class Model: ObservableObject {
        
        private let storage: Storage
        
        private let target: Binding<Bookmark>
        @Published var bookmark: Bookmark

        private(set) var onCompletion: (Action, Binding<PresentationMode>) -> Void = { _, _ in }
        
        init(bookmark: Binding<Bookmark>, onCompletion: ((Action) -> Void)? = nil) {
            storage = Storage.shared
            target = bookmark
            self.bookmark = bookmark.wrappedValue
            
            self.onCompletion = { [weak self] action, presentationMode in
                defer {
                    onCompletion?(action)
                    presentationMode.wrappedValue.dismiss()
                }
                
                guard let self = self, case .acceptance = action else { return }
                
                if self.target.wrappedValue.folderID != self.bookmark.folderID {
                    (§self.target.wrappedValue.folderID)?
                        .wrappedValue
                        .bookmarks
                        .remove(id: self.target.wrappedValue.id)
                    
                    (§self.bookmark.folderID)?
                        .wrappedValue
                        .bookmarks
                        .insert(self.bookmark, at: 0)
                }
                
                self.target.wrappedValue = self.bookmark
            }
        }
    }
}
