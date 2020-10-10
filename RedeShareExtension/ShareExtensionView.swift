//
//  ShareExtensionView.swift
//  RedeShareExtension
//
//  Created by Marcus Rossel on 29.08.20.
//

import SwiftUI
/*
struct ShareExtensionView: View {
    
    // MARK: State
    
    /* Codable */ @AppStorage("folders", store: .rede)
    private var _folders = Data()
    private var folders: [Folder] {
        get { (try? JSONDecoder().decode([Folder].self, from: _folders)) ?? [] }
        nonmutating set { if let data = try? JSONEncoder().encode(newValue) { _folders = data } }
    }
    
    /* Codable */ @AppStorage("uncategorizedBookmarks", store: .rede)
    private var _uncategorizedBookmarks = Data()
    private var uncategorizedBookmarks: [Bookmark] {
        get { (try? JSONDecoder().decode([Bookmark].self, from: _uncategorizedBookmarks)) ?? [] }
        nonmutating set {
            if let data = try? JSONEncoder().encode(newValue) { _uncategorizedBookmarks = data }
        }
    }
    
    @AppStorage("automaticallyNameBookmarks", store: .rede)
    private var automaticallyNameBookmarks = true
    
    @AppStorage("allowUncategorizedBookmarks", store: .rede)
    private var allowUncategorizedBookmarks = true
    
    @ObservedObject var shareExtensionData: ShareExtensionData
    
    @State private var bookmarkTitle = ""
    @State private var newFolderName = ""
    @State private var bookmarkTitleHasBeenEdited = false
    @State private var saveButtonHasBeenPressed = false
    @State private var selection: Selection = .uncategorized
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                HStack {
                    let textField = Binding<String>(
                        get: { bookmarkTitle },
                        set: {
                            bookmarkTitleHasBeenEdited = true
                            bookmarkTitle = $0
                        }
                    )
                    
                    TextField("Bookmark Title", text: textField)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color.accentColor, lineWidth: 1)
                        )
                        .onReceive(shareExtensionData.$websiteTitle) { websiteTitle in
                            if let title = pastable(websiteTitle: websiteTitle, for: .automatic) {
                                bookmarkTitle = title
                            }
                        }
                    
                    Button(action: {
                        bookmarkTitle = shareExtensionData.websiteTitle!
                        bookmarkTitleHasBeenEdited = false
                    }) {
                        Image(systemName: "arrow.2.circlepath.circle.fill")
                            .font(.system(size: 20))
                    }
                    .disabled(
                        pastable(websiteTitle: shareExtensionData.websiteTitle, for: .manual) == nil
                    )
                    
                    Spacer()
                }
                .padding()
                
                List {
                    Section(header: Text("Destination")) {
                        ForEach(folders) { folder in
                            let index = folders.firstIndex(of: folder)!
                            let folderBinding = Binding<Folder>(
                                get: { folder },
                                set: { folders[index] = $0 }
                            )
                            
                            FolderCell(folder: folderBinding)
                                .listRowBackground(selection.folderIndex == index ? .accentColor : Color.clear)
                                .onTapGesture { selection = .folder(index: index) }
                        }
                    }
                    
                    Section {
                        Label(
                            title: {
                                TextField("New Folder", text: $newFolderName)
                            },
                            icon: {
                                Image(systemName: "folder.badge.plus")
                                    .foregroundColor(
                                        newFolderNameIsDuplicate && selection != .newFolder
                                            ? .red
                                            : .primary
                                    )
                            }
                        )
                        .listRowBackground(selection == .newFolder ? .accentColor : Color.clear)
                        .onTapGesture { selection = .newFolder }
                        
                        if newFolderNameIsDuplicate {
                            Text("This name is already being used.")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                    }
                    
                    if allowUncategorizedBookmarks {
                        Section {
                            Label("Uncategorized", systemImage: "bin.xmark.fill")
                                .listRowBackground(selection == .uncategorized ? .accentColor : Color.clear)
                                .onTapGesture { selection = .uncategorized }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarTitle("Rede", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Save", action: saveBookmark).disabled(!savingIsAllowed),
                trailing: Button("Cancel", action: dismiss)
            )
        }
    }
    
    // MARK: Conditions
    
    private var savingIsAllowed: Bool {
        !bookmarkTitle.isEmpty &&
        shareExtensionData.url != nil &&
        (selection != .uncategorized || allowUncategorizedBookmarks) &&
        (selection != .newFolder || newFolderNameIsValid)
    }
    
    private var newFolderNameIsValid: Bool {
        !newFolderName.isEmpty && !newFolderNameIsDuplicate
    }
    
    private var newFolderNameIsDuplicate: Bool {
        !(saveButtonHasBeenPressed && selection == .newFolder) &&
        folders.contains { folder in folder.name == newFolderName }
    }
    
    private func pastable(websiteTitle: String?, for pasteStyle: PasteStyle) -> String? {
        guard
            pasteStyle.requiresPreviousEditing == bookmarkTitleHasBeenEdited,
            let title = websiteTitle, !title.isEmpty
        else { return nil }
        
        switch pasteStyle {
        case .automatic: return automaticallyNameBookmarks ? title : nil
        case .manual:      return title
        }
    }
    
    // MARK: Actions
    
    private func saveBookmark() {
        saveButtonHasBeenPressed = true
        
        let bookmark = Bookmark(title: bookmarkTitle, url: shareExtensionData.url!)
        
        switch selection {
        case .folder(index: let index):
            folders[index].bookmarks.insert(bookmark, at: 0)
        case .newFolder:
            let newFolder = Folder(name: newFolderName, bookmarks: [bookmark])
            folders.insert(newFolder, at: 0)
        case .uncategorized:
            uncategorizedBookmarks.insert(bookmark, at: 0)
        }
        
        dismiss()
    }
    
    private func dismiss() {
        guard let controller = shareExtensionData.shareExtensionController else { return }
        controller.extensionContext!.completeRequest(returningItems: nil)
    }
}

// MARK: - Selection

extension ShareExtensionView {
    
    enum Selection: Equatable {
        
        case folder(index: Int)
        case newFolder
        case uncategorized
        
        var folderIndex: Int? {
            if case .folder(let index) = self { return index } else { return nil }
        }
    }
}

// MARK: - Selection

extension ShareExtensionView {
    
    enum PasteStyle {
        case automatic
        case manual
        
        var requiresPreviousEditing: Bool {
            switch self {
            case .automatic: return false
            case .manual: return true
            }
        }
    }
}
*/
