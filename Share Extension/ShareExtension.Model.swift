//
//  ShareExtension.Model.swift
//  Rede / Share Extension
//
//  Created by Marcus Rossel on 11.11.20.
//

import Combine
import Foundation
import SwiftSoup
import MobileCoreServices

extension ShareExtension {
    
    final class Model: ObservableObject {
        
        /// The Uniform Type Identifier for URLs as provided by `MobileCoreServices`.
        private let urlUTI = kUTTypeURL as String
        
        @Published var websiteTitle: String?
        @Published var url: URL?

        private let controller: Controller
        
        func dismissShareExtension() {
            controller.extensionContext?.completeRequest(returningItems: nil)
        }

        init(controller: Controller) {
            self.controller = controller
            loadURLAndTitle()
        }
        
        private func loadURLAndTitle() {
            guard
                let inputItems = controller.extensionContext?.inputItems,
                let firstExtensionItem = inputItems.first as? NSExtensionItem,
                let attachments = firstExtensionItem.attachments
            else {
                url = nil
                return
            }
            
            let urlProviders = attachments.filter { $0.hasItemConformingToTypeIdentifier(urlUTI) }
            
            guard !urlProviders.isEmpty else { url = nil; return }
            
            for provider in urlProviders {
                provider.loadItem(forTypeIdentifier: urlUTI) { (data, error) in
                    DispatchQueue.main.async {
                        if self.url == nil {
                            self.url = (error == nil) ? (data as? URL) : nil
                        }
                        
                        if self.websiteTitle == nil {
                            self.websiteTitle = self.websiteTitle(for: self.url)
                        }
                    }
                }
            }
        }
        
        private func websiteTitle(for url: URL?) -> String? {
            guard let url = url else { return nil }
            
            var html = try? String(contentsOf: url, encoding: .utf8)
            if html == nil { html = try? String(contentsOf: url, encoding: .ascii) }
            guard html != nil else { return nil }
            
            let title = try? SwiftSoup.parse(html!).title()
            return title?.isEmpty == true ? nil : title
        }
    }
}

