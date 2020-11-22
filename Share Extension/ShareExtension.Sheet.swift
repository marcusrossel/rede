//
//  ShareExtension.Sheet.swift
//  Rede / Share Extension
//
//  Created by Marcus Rossel on 11.11.20.
//

import SwiftUI
import DataField

extension ShareExtension {
    
    struct Sheet: View {
        
        @StateObject private var storage: Storage = .shared
        @ObservedObject var model: Model
        
        @State private var destination: Folder.ID?
        
        private var title: Binding<String> {
            Binding { model.websiteTitle ?? "" } set: { model.websiteTitle = $0 }
        }
        
        private var saveIsDisabled: Bool {
            guard let title = model.websiteTitle, model.url != nil else { return true }
            return destination == nil || title.isEmpty
        }
        
        var body: some View {
            NavigationView {
                VStack {
                    TextField("Bookmark Title", text: title)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .padding([.leading, .trailing, .top])
                        .padding(.top, 8)
                    
                    HStack {
                        DataField("URL", data: $model.url) { text in
                            guard let url = URL(string: text) else { return (nil as URL??) }
                            return url
                        } dataToText: { url in
                            url?.absoluteString ?? ""
                        }
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    }
                    .font(.footnote)
                    .padding([.leading, .trailing], 32)
                    .padding(.bottom, 14)
                    
                    FolderPicker(title: "Destination", selection: $destination)
                }
                .navigationBarTitle("New Bookmark", displayMode: .large)
                .navigationBarItems(
                    leading:
                        Button("Cancel", action: model.dismissShareExtension),
                    trailing:
                        Button("Save") {
                            let bookmark = Bookmark(
                                title: model.websiteTitle!,
                                url: model.url!,
                                folderID: destination!
                            )
                            storage.folders[volatile: destination!]?.bookmarks.insert(bookmark, at: 0)
                            try? storage.save()
                            model.dismissShareExtension()
                        }
                        .disabled(saveIsDisabled)
                )
            }
        }
    }
}

