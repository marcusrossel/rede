//
//  FolderEditor.swift
//  Rede / App
//
//  Created by Marcus Rossel on 08.11.20.
//

import SwiftUI
import Combine

struct FolderEditor: View {
    
    enum Completion { case done, cancel }
    
    init(folder: Binding<Folder>, onCompletion: ((Completion) -> Void)? = nil) {
        let model = Model(folder: folder, onCompletion: onCompletion)
        _model = StateObject(wrappedValue: model)
    }

    @StateObject private var model: Model
    
    @Environment(\.presentationMode) private var presentationMode
    private let defaultColors = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6958661223, blue: 0.1375563212, alpha: 1), #colorLiteral(red: 0.9592913348, green: 0.8808340757, blue: 0, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.1826183216, green: 0.5399370489, blue: 1, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.817692547, green: 0.5427757314, blue: 1, alpha: 1), #colorLiteral(red: 0.7439069119, green: 0.5957958577, blue: 0.4106654354, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)].map(Color.init)
    private let columns = Array(repeating: GridItem(), count: 6)
    private let gridItemSize: CGFloat = 48
    private let gridSpacing: CGFloat = 12
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer(minLength: 24)
                
                Image(systemName: model.folder.icon.name)
                    .foregroundColor(model.folder.icon.color)
                    .font(.system(size: 60))
                
                HStack {
                    TextField("Folder Name", text: $model.folder.name)
                        .font(.system(size: 24))
                        .multilineTextAlignment(.center)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(model.currentNameIsValid ? .all : [.top, .bottom, .leading])
                    
                    if !model.currentNameIsValid {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .renderingMode(.original)
                            .font(.system(size: 24))
                            .padding([.top, .bottom, .trailing])
                    }
                }
                
                LazyVGrid(columns: columns, spacing: gridSpacing) {
                    ForEach(defaultColors, id: \.self) { color in
                        color
                            .frame(minWidth: gridItemSize, minHeight: gridItemSize)
                            .clipShape(Circle())
                            .onTapGesture { model.folder.icon.color = color }
                    }
                    
                    ColorPicker("Folder Color", selection: $model.folder.icon.color)
                        .labelsHidden()
                }
                .padding([.leading, .trailing, .bottom])
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: gridSpacing) {
                        ForEach(SFSymbols.all, id: \.self) { name in
                            Color(.secondarySystemBackground)
                                .frame(minWidth: gridItemSize, minHeight: gridItemSize)
                                .clipShape(Circle())
                                .overlay(Image(systemName: name))
                                .onTapGesture { model.folder.icon.name = name }
                        }
                    }
                }
                .padding([.leading, .trailing])
            }
            .navigationBarTitle(model.folderIsNew ? "New Folder" : "Edit Folder", displayMode: .inline)
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
                    .disabled(!model.currentNameIsValid)
            )
        }
    }
}

// MARK: View Model

extension FolderEditor {
    
    fileprivate final class Model: ObservableObject {
    
        @Published private var storage: Storage = .shared
        
        @Binding private var original: Folder
        @Published var folder: Folder
        
        private(set) var onCompletion: (Completion, Binding<PresentationMode>) -> Void = { _, _ in }
        
        @Published var currentNameIsValid: Bool
        let folderIsNew: Bool
        
        private var subscription: AnyCancellable?
        
        init(folder: Binding<Folder>, onCompletion: ((Completion) -> Void)? = nil) {
            _original = folder
            self.folder = folder.wrappedValue
            
            folderIsNew = folder.wrappedValue.name.isEmpty
            currentNameIsValid = !folderIsNew
            
            subscription = $folder
                .map(\.name)
                .map(isAvailable(name:))
                .sink { [weak self] in self?.currentNameIsValid = $0 }
            
            self.onCompletion = { [weak self] completion, presentationMode in
                if let self = self, case .done = completion { folder.wrappedValue = self.folder }
                onCompletion?(completion)
                presentationMode.wrappedValue.dismiss()
            }
        }
        
        private func isAvailable(name: String) -> Bool {
            !name.isEmpty &&
            (name == original.name || storage.folders.allSatisfy { $0.name != name })
        }
    }
}