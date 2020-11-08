//
//  FoldersEditor.swift
//  Rede
//
//  Created by Marcus Rossel on 30.08.20.
//

import SwiftUI
import Combine

struct FoldersEditor: View {
    
    @StateObject private var model = Model()
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 22) {
                    // https://stackoverflow.com/a/58634704/3208492
                    Image(systemName: "plus.circle.fill")
                        .renderingMode(model.newFolderNameIsValid ? .original : .template)
                        .foregroundColor(.secondary)
                        .font(.system(size: 21.5))
                        .onTapGesture(perform: addNewFolder)
                        .disabled(!model.newFolderNameIsValid)
                        
                    Label {
                        TextField("New Folder", text: $model.newFolder.name)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.secondary, lineWidth: 0.2)
                            )
                    } icon: {
                        IconPicker(icon: $model.newFolder.icon)
                    }
                }
                .padding(EdgeInsets(top: 2, leading: 1, bottom: 2, trailing: 46))
            }
            
            Section {
                ForEach(model.folders.indexed()) { row in
                    FolderEditor(folder: $model.folders[row.index])
                        .padding([.top, .bottom], 2)
                }
                .onMove(perform: move(from:to:))
                .onDelete(perform: delete(at:))
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Folder Setup", displayMode: .inline)
        .environment(\.editMode, .constant(.active))
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        model.folders.move(fromOffsets: source, toOffset: destination)
    }
    
    private func delete(at offsets: IndexSet) {
        model.folders.remove(atOffsets: offsets)
    }
    
    private func addNewFolder() {
        model.folders.insert(model.newFolder, at: 0)
        model.newFolder = Folder(name: "")
    }
}

// MARK: View Model

extension FoldersEditor {
    
    final class Model: ObservableObject {
        
        // Input
        @Published var newFolder = Folder(name: "")
        
        // Output
        @Published private(set) var newFolderNameIsValid = false
        
        // Routing
        @Published private var storage: Storage = .shared
        var folders: [Folder] {
            get { storage.folders }
            set { storage.folders = newValue }
        }

        // Subscriptions
        private var subscriptions: Set<AnyCancellable> = []
        
        private var assignNewFolderNameIsValid: AnyCancellable {
            $newFolder
                .map { new in
                    !new.name.isEmpty && self.storage.folders.allSatisfy { existing in
                        new.name != existing.name
                    }
                }
                .removeDuplicates()
                .assign(to: \.newFolderNameIsValid, on: self)
        }
        
        init() {
            subscriptions = [assignNewFolderNameIsValid]
        }
    }
}

// MARK: Previews

struct FoldersEditor_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            FoldersEditor()
                .onAppear { Storage.shared.folders = Folder.previewData }
        }
    }
}
