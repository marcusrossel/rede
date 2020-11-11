//
//  Home.swift
//  Rede
//
//  Created by Marcus Rossel on 08.11.20.
//

import SwiftUI

struct Home: View {
    
    @StateObject var storage: Storage = .shared
    
    @State private var sheet: Sheet? = nil
    @State private var rowInDeletion: Row<Folder>? = nil
    @State private var isReordering = false
    
    @State private var newFolder = Folder(name: "")
    
    var body: some View {
        VStack {
            if storage.folders.isEmpty {
                NoFolders /*onTapGesture:*/ {
                    sheet = .newFolder
                }
            }
            
            List {
                ForEach(storage.folders.indexed()) { row in
                    FolderRow(row: row)
                        .contextMenu { isReordering ? nil : contextMenu(for: row) }
                }
                .onDelete(perform: isReordering ? nil : onDelete(offsets:))
                .onMove(perform: onMove(offsets:destination:))
            }
            .listStyle(InsetGroupedListStyle())
            .environment(\.editMode, .constant(isReordering ? .active : .inactive))
            .sheet(item: $sheet) { sheet in
                switch sheet {
                case .newFolder:
                    FolderEditor(folder: $newFolder) { completion in
                        guard case .done = completion else { return }
                        storage.folders.insert(newFolder, at: 0)
                        newFolder = Folder(name: "")
                    }
                case .edit(let row):
                    let binding = Binding<Folder> {
                        storage.folders[row.index]
                    } set: {
                        storage.folders[row.index] = $0
                    }
                    
                    FolderEditor(folder: binding)
                case .merge(let row):
                    FolderMerger(source: row)
                }
            }
            .actionSheet(item: $rowInDeletion, content: actionSheet(for:))
            .navigationBarItems(leading:
                Group {
                    if isReordering {
                        Button("Done") {
                            withAnimation { isReordering = false }
                        }
                    }
                }
            )
        }
        .navigationBarTitle("Rede")
        .navigationBarItems(trailing:
            Menu {
                Button {
                    sheet = .newFolder
                } label: {
                    Label("New Folder", systemImage: "folder.fill.badge.plus")
                }
                
                if storage.folders.count > 1 {
                    Button {
                        withAnimation { isReordering = true }
                    } label: {
                        Label("Reorder Folders", systemImage: "rectangle.arrowtriangle.2.outward")
                    }
                }

            } label: {
                Image(systemName: "ellipsis.circle.fill")
            }
        )
    }
    
    private func onDelete(offsets: IndexSet) {
        guard let index = offsets.first, let folder = storage.folders[safe: index] else { return }
        
        // To avoid buggy animations on swipe to delete, the row is deleted right away, but retained
        // in `rowInDeletion`, so it can be restored if the user aborts the action.
        // This should also fix a broken layout constraint issue.
        storage.folders.remove(at: index)
        
        if !folder.bookmarks.isEmpty {
            rowInDeletion = Row(index: index, element: folder)
        }
    }
    
    private func onMove(offsets: IndexSet, destination: Int) {
        storage.folders.move(fromOffsets: offsets, toOffset: destination)
    }
    
    private func contextMenu(for row: Row<Folder>) -> some View {
        Group {
            Button { sheet = .edit(row: row) } label: {
                Text("Edit")
                Image(systemName: "slider.horizontal.3")
            }
            
            Button {
                // Cf. `onDelete(offsets:)`.
                //
                // TODO: Figure out how to make this animation nicer.
                _ = withAnimation {
                    storage.folders.remove(at: row.index)
                }
                rowInDeletion = row
            } label: {
                Text("Delete")
                Image(systemName: "minus.circle.fill")
            }
        }
    }
    
    private func actionSheet(for row: Row<Folder>) -> ActionSheet {
        ActionSheet(
            title: Text("Delete \"\(row.element.name)\""),
            message: Text("This will also delete all of the folder's bookmarks."),
            buttons: [
                .destructive(Text("Delete")), // Cf. `onDelete(offsets:)`.
                
                storage.folders.count <= 1
                    ? nil
                    : .default(Text("Merge Into Other Folder")) { sheet = .merge(row: row) },
                
                .cancel {
                    withAnimation {
                        storage.folders.insert(row.element, at: row.index)
                    }
                }
            ].compactMap { $0 }
        )
    }
}


// MARK: Sheet

extension Home {
    
    enum Sheet: Identifiable, Hashable {
        
        case newFolder
        case edit(row: Row<Folder>)
        case merge(row: Row<Folder>)
        
        var id: Sheet { self }
    }
}
