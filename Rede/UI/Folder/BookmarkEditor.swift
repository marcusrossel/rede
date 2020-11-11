//
//  BookmarkEditor.swift
//  Rede
//
//  Created by Marcus Rossel on 09.11.20.
//

import SwiftUI
import DataField

struct BookmarkEditor: View {
    
    enum Completion { case done, cancel }
    
    init(row: Row<Bookmark>, in folder: Binding<Folder>, onCompletion: ((Completion) -> Void)? = nil) {
        let model = Model(row: row, in: folder, onCompletion: onCompletion)
        _model = StateObject(wrappedValue: model)
    }
    
    @StateObject private var model: Model
    
    @State private var urlIsValid = true
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var starRotation = Angle(degrees: 0)
    @State private var bookRotation = Angle(degrees: 0)
    
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
                    .padding(.top, 8)
                
                HStack {
                    DataField("URL", data: $model.bookmark.url, invalidText: { invalidText in
                        urlIsValid = invalidText == nil
                    })
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    
                    if !urlIsValid {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .renderingMode(.original)
                    }
                }
                .font(.footnote)
                .padding([.leading, .trailing], 32)
                .padding(.bottom, 14)
                
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation {
                            bookRotation.degrees += 180
                            model.bookmark.readDate = (model.bookmark.readDate == nil) ? Date() : nil
                        }
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: "book\(model.bookmark.readDate == nil ? "" : ".fill")")
                                .rotation3DEffect(bookRotation, axis: (x: 0, y: 1, z: 0))
                                .foregroundColor(Color(#colorLiteral(red: 1, green: 0.2635219395, blue: 0.2254285514, alpha: 1)))
                                .font(.system(size: 30))

                            Text("Read")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: 120, maxHeight: 120)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(Circle())
                    }

                    Spacer()
                    
                    Button {
                        withAnimation {
                            starRotation.degrees += 72
                            model.bookmark.isFavorite.toggle()
                        }
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: "star\(model.bookmark.isFavorite ? ".fill" : "")")
                                .rotationEffect(starRotation)
                                .foregroundColor(Color(#colorLiteral(red: 1, green: 0.8410827518, blue: 0.05768922716, alpha: 1)))
                                .font(.system(size: 30))

                            Text("Favorite")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: 120, maxHeight: 120)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(Circle())
                    }
                    
                    Spacer()
                }
                
                FolderPicker(title: "Folder", selection: $model.folderRow)
            }
            .navigationBarTitle("\(model.bookmarkIsNew ? "New" : "Edit") Bookmark", displayMode: .inline)
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
        
        private let storage: Storage = .shared
    
        private let indexOfBookmarkInEdit: Int
        private let indexOfFolderInEdit: Int
        
        @Published var bookmark: Bookmark
        @Published var folderRow: Row<Folder>
        
        let bookmarkIsNew: Bool

        private(set) var onCompletion: (Completion, Binding<PresentationMode>) -> Void = { _, _ in }
        
        init(row: Row<Bookmark>, in folder: Binding<Folder>, onCompletion: ((Completion) -> Void)? = nil) {
            guard let folderIndex = storage.folders.firstIndex(of: folder.wrappedValue) else {
                fatalError("Assumption of '\(Self.self)' broken")
            }
            
            indexOfBookmarkInEdit = row.index
            indexOfFolderInEdit = folderIndex
            
            self.bookmark = row.element
            self.folderRow = Row(index: indexOfFolderInEdit, element: folder.wrappedValue)
            
            bookmarkIsNew = row.element.title.isEmpty
            
            self.onCompletion = { [weak self] completion, presentationMode in
                defer {
                    onCompletion?(completion)
                    presentationMode.wrappedValue.dismiss()
                }
                
                guard let self = self, case .done = completion else { return }
                
                self.storage.folders[self.indexOfFolderInEdit].bookmarks[self.indexOfBookmarkInEdit] = self.bookmark
                
                if self.indexOfFolderInEdit != self.folderRow.index {
                    self.storage.folders[self.indexOfFolderInEdit].bookmarks.remove(at: self.indexOfBookmarkInEdit)
                    self.storage.folders[self.folderRow.index].bookmarks.insert(self.bookmark, at: 0)
                }
                
                
            }
        }
    }
}
