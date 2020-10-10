//
//  FoldersEditor.swift
//  Rede
//
//  Created by Marcus Rossel on 30.08.20.
//

import SwiftUI

struct FoldersEditor: View {
    
    @EnvironmentObject private var shelf: Shelf
    
    @State private var newFolder = Folder(name: "")
    
    private func index(for folder: Folder) -> Int {
        if let folderIndex = shelf.folders.firstIndex(of: folder) {
            return folderIndex
        } else {
            fatalError("Folder '\(folder.name)' is not in the shelf.")
        }
    }
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 22) {
                    // https://stackoverflow.com/a/58634704/3208492
                    Image(systemName: "plus.circle.fill")
                        .renderingMode(newFolder.name.isEmpty ? .template : .original)
                        .foregroundColor(.secondary)
                        .font(.system(size: 21.5))
                        .onTapGesture(perform: addNewFolder)
                        .disabled(newFolder.name.isEmpty)
                        
                    Label {
                        TextField("New Folder", text: $newFolder.name)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.secondary, lineWidth: 0.2)
                            )
                    } icon: {
                        IconPicker(icon: $newFolder.icon)
                    }
                }
                .padding(EdgeInsets(top: 2, leading: 1, bottom: 2, trailing: 46))
            }
            
            Section {
                ForEach(shelf.folders) { folder in
                    FolderEditor(folder: $shelf.folders[index(for: folder)])
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
        shelf.folders.move(fromOffsets: source, toOffset: destination)
    }
    
    private func delete(at offsets: IndexSet) {
        shelf.folders.remove(atOffsets: offsets)
    }
    
    private func addNewFolder() {
        shelf.folders.insert(newFolder, at: 0)
        newFolder = Folder(name: "")
    }
}

// MARK: - Custom Alignment

extension HorizontalAlignment {
    
    static let folderSetup = HorizontalAlignment(FolderSetup.self)
    
    struct FolderSetup: AlignmentID {
        
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.leading]
        }
    }
}

// MARK: - Previews

struct FoldersEditor_Previews: PreviewProvider {
    
    static var previews: some View {
        StatefulPreview()
    }
    
    /// A `View` that is used for the preview, as `@State` doesn't work on non-`View`s.
    struct StatefulPreview: View {
        
        @StateObject private var shelf = Shelf.previewData
        
        var body: some View {
            NavigationView {
                FoldersEditor()
                    .environmentObject(shelf)
            }
        }
    }
}
