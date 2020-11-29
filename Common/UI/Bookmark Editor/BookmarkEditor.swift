//
//  BookmarkEditor.swift
//  Rede / Common
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
        NavigationView {
            VStack {
                TextField("Bookmark Title", text: $model.bookmark.title)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding([.leading, .trailing, .top])
                    
                
                URLField(url: $model.bookmark.url)
                    .font(.footnote)
                    .padding([.leading, .trailing], 32)
                    .padding(.bottom, 27)
                
                Divider()
                
                HStack {
                    Spacer()
                    FavoriteButton(isFavorite: $model.bookmark.isFavorite)
                    Spacer()
                    ReadButton(readDate: $model.bookmark.readDate)
                    Spacer()
                }
                .padding(.top, 8)
                
                Divider()
                
                FolderPicker(title: "Folder", selection: $model.bookmark.folderID)
                    .padding([.top], 20)
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
                    .disabled(!model.bookmarkIsComplete)
            )
        }
    }
}

// MARK: View Model

extension BookmarkEditor {
    
    fileprivate final class Model: ObservableObject {
        
        @Published private var storage: Storage = .shared
        @Binding private var target: Bookmark
        @Published var bookmark: Bookmark

        var bookmarkIsComplete: Bool {
            !bookmark.title.isEmpty && bookmark.folderID != nil
        }
        
        private(set) var onCompletion: (Action, Binding<PresentationMode>) -> Void = { _, _ in }
        
        init(bookmark: Binding<Bookmark>, onCompletion: ((Action) -> Void)? = nil) {
            _target = bookmark
            self.bookmark = bookmark.wrappedValue
            
            self.onCompletion = { [weak self] action, presentationMode in
                defer {
                    onCompletion?(action)
                    presentationMode.wrappedValue.dismiss()
                }
                
                guard
                    let self = self, case .acceptance = action,
                    let destinationID = self.bookmark.folderID
                else { return }
                
                let sourceID = self.target.folderID
                
                self.target = self.bookmark
                
                if let sourceID = sourceID {
                    if sourceID != destinationID {
                        self.storage.folders[permanent: destinationID].bookmarks.insert(self.bookmark, at: 0)
                        self.storage.folders[permanent: sourceID].bookmarks.remove(id: self.target.id)
                    }
                } else {
                    self.storage.folders[permanent: destinationID].bookmarks.insert(self.bookmark, at: 0)
                }
            }
        }
    }
}
