//
//  Home.swift
//  Rede / App
//
//  Created by Marcus Rossel on 08.11.20.
//

import SwiftUI
import Combine

struct Home: View {
    
    @StateObject var model = Model()
    
    @State private var sheet: Sheet? = nil
    @State private var folderInDeletion: Folder? = nil
    
    @Environment(\.editMode) private var editMode
    @State private var newFolder = Folder(name: "")
    
    var body: some View {
        VStack {
            if model.showNoFolders {
                NoFolders(onTapGesture: editNewFolder)
                    .zIndex(1)
                    .transition(.opacity)
            }
            
            List {
                ForEach(model.storage.folders) { folder in
                    let binding = $model.storage.folders[permanent: folder.id]
                    FolderRow(folder: binding)
                        .contextMenu {
                            ContextMenu(
                                folder: binding,
                                editMode: editMode,
                                sheet: $sheet,
                                folderInDeletion: $folderInDeletion
                            )
                        }
                }
                .onDelete(perform: onDelete)
                .onMove(perform: onMove(offsets:destination:))
            }
            .listStyle(InsetGroupedListStyle())
        }
        .environment(\.editMode, editMode)
        .navigationBarTitle("Folders")
        .navigationBarItems(trailing: BarButton(sheet: $sheet, editMode: editMode, onNewFolder: editNewFolder))
        .sheet(item: $sheet) { $0 }
        .actionSheet(item: $folderInDeletion, content: actionSheet(for:))
    }
    
    private var onDelete: ((IndexSet) -> Void)? {
        switch editMode?.wrappedValue {
        case .active:
            return nil
        default:
            return { offsets in
                guard let index = offsets.first else { return }
                
                // Since the folders in this context are considered "permanent", their number can
                // only stay constant or grow, so this direct subscript via `index` is at least
                // safe.
                let folder = model.storage.folders[index]
                
                if folder.bookmarks.isEmpty {
                    model.storage.folders.remove(id: folder.id)
                } else {
                    folderInDeletion = folder
                }
            }
        }
    }
    
    private func onMove(offsets: IndexSet, destination: Int) {
        model.storage.folders.move(fromOffsets: offsets, toOffset: destination)
    }
    
    private func editNewFolder() {
        sheet = .new(folder: $newFolder)
    }
    
    private func actionSheet(for folder: Folder) -> ActionSheet {
        let delete: ActionSheet.Button = .destructive(Text("Delete")) {
            model.storage.backup[folder.id] = folder
            model.storage.folders.remove(id: folder.id)
        }
        let merge: ActionSheet.Button = .default(Text("Merge")) {
            sheet = .merge(folder: $model.storage.folders[permanent: folder.id])
        }
        
        return ActionSheet(
            title: Text("Delete \"\(folder.name)\"?"),
            message: Text("This will also delete all of the folder's bookmarks."),
            buttons: [delete, model.storage.folders.count > 1 ? merge : nil, .cancel()].compactMap { $0 }
        )
    }
}


// MARK: View Model

extension Home {
    
    final class Model: ObservableObject {
        
        @Published var storage: Storage
        @Published private(set) var showNoFolders: Bool
        
        private var subscriptions: Set<AnyCancellable> = []
        
        init() {
            let storage = Storage.shared
            
            self.storage = storage
            showNoFolders = storage.folders.isEmpty
            
            storage.$folders
                .map(\.isEmpty)
                .sink { [weak self] value in withAnimation { self?.showNoFolders = value } }
                .store(in: &subscriptions)
        }
    }
}
