//
//  ShareExtensionController.swift
//  Rede / Share Extension
//
//  Created by Marcus Rossel on 11.11.20.
//

import SwiftUI
import UIKit

@objc(ShareExtensionController)
final class ShareExtensionController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shareExtensionView = Text("\(Storage.shared.folders.map(\.name).joined(separator: ","))")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
        
        // Adds the hosting controller that shows the share extension view.
        let hostingController = UIHostingController(rootView: shareExtensionView)
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        overlay(view: hostingController.view)
    }
    
    /// A convenience function for completely overlaying the controller's view with a given view.
    private func overlay(view overlay: UIView) {
        view.addSubview(overlay)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            overlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            overlay.heightAnchor.constraint(equalTo: view.heightAnchor),
            overlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overlay.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
