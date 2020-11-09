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
    
    var body: some View {
        List {
            ForEach(storage.folders.indexed()) { row in
                FolderRow(folder: $storage.folders[row.index])
                    .contextMenu { isReordering ? nil : contextMenu(for: row) }
            }
            .onDelete(perform: isReordering ? nil : onDelete(offsets:))
            .onMove(perform: onMove(offsets:destination:))
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Rede")
        .navigationBarItems(
            leading: isReordering
                ? AnyView(Button("Done") { withAnimation { isReordering = false } })
                : AnyView(EmptyView()),
            trailing:
                Menu {
                    Button {
                        
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
        .environment(\.editMode, .constant(isReordering ? .active : .inactive))
        .sheet(item: $sheet) { sheet in
            switch sheet.style {
            case .edit:  FolderEditor(folder: $storage.folders[sheet.row.index])
            case .merge: FolderMerger(source: sheet.row)
            }
        }
        .actionSheet(item: $rowInDeletion) { row in
            ActionSheet(
                title: Text("Delete \"\(row.element.name)\""),
                message: Text("This will also delete all of the folder's bookmarks."),
                buttons: [
                    .destructive(Text("Delete")) {
                        _ = withAnimation { storage.folders.remove(at: row.index) }
                    },
                    storage.folders.count <= 1 ? nil : .default(Text("Merge Into Other Folder")) {
                        sheet = .merge(row: row)
                    },
                    .cancel()
                ].compactMap { $0 }
            )
        }
    }
    
    private func onDelete(offsets: IndexSet) {
        guard let index = offsets.first, let folder = storage.folders[safe: index] else { return }
        
        if folder.bookmarks.isEmpty {
            _ = withAnimation { storage.folders.remove(at: index) }
        } else {
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
            
            Button { rowInDeletion = row } label: {
                Text("Delete")
                Image(systemName: "minus.circle.fill")
            }
        }
    }
}


// MARK: Sheet

extension Home {
    
    struct Sheet: Identifiable, Hashable {
        
        enum Style: Hashable { case edit, merge }
        
        static func edit(row: Row<Folder>) -> Sheet  { Sheet(style: .edit,  row: row) }
        static func merge(row: Row<Folder>) -> Sheet { Sheet(style: .merge, row: row) }
        
        let style: Style
        let row: Row<Folder>
        
        private init(style: Style, row: Row<Folder>) {
            self.style = style
            self.row = row
        }
        
        var id: Sheet { self }
    }
}
