//
//  ShareExtensionData.swift
//  RedeShareExtension
//
//  Created by Marcus Rossel on 05.09.20.
//

import SwiftUI
import MobileCoreServices
import SwiftSoup

final class ShareExtensionData: ObservableObject {
    
    /// The Uniform Type Identifier for URLs as provided by `MobileCoreServices`.
    private let urlUTI = kUTTypeURL as String
    
    @Published private(set) var websiteTitle: String?
    private(set) var url: URL? { didSet { websiteTitle = websiteTitle(for: url) } }
    
    private(set) var shareExtensionController: ShareExtensionController?

    /// Fetches the URL provided to the share extension asynchronously.
    func update(for controller: ShareExtensionController) {
        shareExtensionController = controller
        
        guard
            let inputItems = controller.extensionContext?.inputItems,
            let firstExtensionItem = inputItems.first as? NSExtensionItem,
            let attachments = firstExtensionItem.attachments
        else { url = nil; return }

        let urlProviders = attachments.filter { $0.hasItemConformingToTypeIdentifier(urlUTI) }
        
        guard !urlProviders.isEmpty else { url = nil; return }
        
        for provider in urlProviders {
            provider.loadItem(forTypeIdentifier: urlUTI) { (data, error) in
                DispatchQueue.main.async {
                    self.url = (error == nil) ? (data as? URL) : nil
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
